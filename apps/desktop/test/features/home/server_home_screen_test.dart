import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/core/error/failures.dart';
import 'package:kontrol_desktop/core/result/api_result.dart';
import 'package:kontrol_desktop/core/theme/server_theme.dart';
import 'package:kontrol_desktop/core/window/window_shell.dart';
import 'package:kontrol_desktop/features/devices/data/datasources/fake_devices_data_source.dart';
import 'package:kontrol_desktop/features/devices/data/repos/devices_repository_impl.dart';
import 'package:kontrol_desktop/features/devices/domain/entities/paired_device.dart';
import 'package:kontrol_desktop/features/devices/domain/repos/devices_repository.dart';
import 'package:kontrol_desktop/features/home/presentation/screens/server_home_screen.dart';
import 'package:kontrol_desktop/features/pairing/data/datasources/fake_pairing_data_source.dart';
import 'package:kontrol_desktop/features/pairing/data/repos/pairing_repository_impl.dart';
import 'package:kontrol_desktop/features/pairing/domain/entities/pairing_code.dart';
import 'package:kontrol_desktop/features/pairing/domain/repos/pairing_repository.dart';
import 'package:kontrol_desktop/features/pairing/domain/usecases/get_pairing_code_usecase.dart';
import 'package:kontrol_desktop/features/pairing/domain/usecases/regenerate_pairing_code_usecase.dart';
import 'package:kontrol_desktop/features/pairing/presentation/cubit/pairing_cubit.dart';

import '../../helpers/kontrol_fonts.dart';
import '../devices/presentation/devices_cubit_test.dart' show buildDevicesCubit;
import '../server/fake_server_repository.dart';
import '../server/presentation/server_cubit_test.dart' show buildServerCubit;

class _FakeShell implements WindowShell {
  final calls = <String>[];

  @override
  void configure() => calls.add('configure');

  @override
  void startDragging() => calls.add('drag');

  @override
  void minimize() => calls.add('minimize');

  @override
  void close() => calls.add('close');

  @override
  void show() => calls.add('show');
}

class _FailingPairingRepo implements PairingRepository {
  @override
  Future<ApiResult<PairingCode>> getCode() async =>
      const ApiError(UnexpectedFailure('x'));

  @override
  Future<ApiResult<PairingCode>> regenerate() async =>
      const ApiError(UnexpectedFailure('x'));
}

/// Real devices list whose actions always fail.
class _FailingActionsRepo implements DevicesRepository {
  _FailingActionsRepo(this._inner);

  final DevicesRepository _inner;

  @override
  Stream<ApiResult<List<PairedDevice>>> watchDevices() => _inner.watchDevices();

  @override
  Future<ApiResult<void>> disconnect(String id) async =>
      const ApiError(UnexpectedFailure('x'));

  @override
  Future<ApiResult<void>> revoke(String id) async =>
      const ApiError(UnexpectedFailure('x'));
}

final _now = DateTime(2026, 11, 1, 12);

void main() {
  setUpAll(loadKontrolFonts);

  late _FakeShell shell;
  late FakeServerRepository serverRepo;
  late StreamController<void> ticks;

  setUp(() {
    shell = _FakeShell();
    serverRepo = FakeServerRepository();
    ticks = StreamController<void>.broadcast();
  });

  tearDown(() => ticks.close());

  DevicesRepository devicesRepo({List<PairedDevice>? seed}) =>
      DevicesRepositoryImpl(FakeDevicesDataSource(now: () => _now, seed: seed));

  Future<void> pumpHome(
    WidgetTester tester, {
    PairingRepository? pairing,
    DevicesRepository? devices,
  }) async {
    tester.view
      ..physicalSize = const Size(820, 560)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final pairingRepo =
        pairing ??
        PairingRepositoryImpl(
          FakePairingDataSource(random: Random(3), now: () => _now),
        );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildServerTheme(),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => buildServerCubit(serverRepo)..load()),
            BlocProvider(
              create: (_) => PairingCubit(
                GetPairingCodeUseCase(pairingRepo),
                RegeneratePairingCodeUseCase(pairingRepo),
                now: () => _now,
                ticker: () => ticks.stream,
              )..start(),
            ),
            BlocProvider(
              create: (_) =>
                  buildDevicesCubit(devices ?? devicesRepo())..start(),
            ),
          ],
          child: ServerHomeScreen(windowShell: shell, now: () => _now),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('ready state renders without layout overflow', (tester) async {
    await pumpHome(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ready state shows the status chip', (tester) async {
    await pumpHome(tester);
    expect(find.text('Ready to pair'), findsOneWidget);
  });

  testWidgets('PIN is shown as two groups of three', (tester) async {
    await pumpHome(tester);
    expect(find.textContaining(RegExp(r'^\d{3} \d{3}$')), findsOneWidget);
  });

  testWidgets('countdown starts at 5:00', (tester) async {
    await pumpHome(tester);
    expect(find.text('New code in 5:00'), findsOneWidget);
  });

  testWidgets('host card shows address with port', (tester) async {
    await pumpHome(tester);
    expect(find.text('192.168.1.24:7531'), findsOneWidget);
    expect(find.text('LIVING-ROOM-PC'), findsOneWidget);
  });

  testWidgets('connected phone row offers Disconnect', (tester) async {
    await pumpHome(tester);
    expect(find.text('Connected now · Android'), findsOneWidget);
    expect(find.text('Disconnect'), findsOneWidget);
  });

  testWidgets('offline phone row offers Revoke', (tester) async {
    await pumpHome(tester);
    expect(find.text('Last seen 3 days ago · iOS'), findsOneWidget);
    expect(find.text('Revoke'), findsOneWidget);
  });

  testWidgets('Revoke removes the phone', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.text('Revoke'));
    await tester.pumpAndSettle();
    expect(find.text('iPhone 15'), findsNothing);
  });

  testWidgets('failed revoke shows a SnackBar', (tester) async {
    await pumpHome(tester, devices: _FailingActionsRepo(devicesRepo()));
    await tester.tap(find.text('Revoke'));
    await tester.pump();
    expect(find.text('Could not revoke. Try again.'), findsOneWidget);
  });

  testWidgets('no phones shows the empty message', (tester) async {
    await pumpHome(tester, devices: devicesRepo(seed: const []));
    expect(
      find.text('No paired phones yet. Scan the code to pair.'),
      findsOneWidget,
    );
  });

  testWidgets('Pause control switches chip and button to paused', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.text('Pause control'));
    await tester.pumpAndSettle();
    expect(find.text('Control paused'), findsOneWidget);
    expect(find.text('Resume control'), findsOneWidget);
  });

  testWidgets('approval switch persists through the repository', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.bySemanticsLabel('Require approval for new devices'));
    await tester.pumpAndSettle();
    expect(serverRepo.controls.requireApproval, isFalse);
  });

  testWidgets('pairing failure shows its message', (tester) async {
    await pumpHome(tester, pairing: _FailingPairingRepo());
    expect(find.text('Could not create a pairing code.'), findsOneWidget);
  });

  testWidgets('host failure shows the network message', (tester) async {
    serverRepo.hostResult = const ApiError(NetworkFailure('x'));
    await pumpHome(tester);
    expect(
      find.text('No network connection. Connect this PC to Wi-Fi.'),
      findsOneWidget,
    );
    expect(find.text('Server stopped'), findsOneWidget);
  });

  testWidgets('Minimize button minimizes the window', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byTooltip('Minimize'));
    expect(shell.calls, ['minimize']);
  });

  testWidgets('Quit button closes the window', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byTooltip('Quit'));
    expect(shell.calls, ['close']);
  });

  testWidgets('dragging the title starts a window drag', (tester) async {
    await pumpHome(tester);
    await tester.drag(find.text('Kontrol Server'), const Offset(40, 0));
    expect(shell.calls, ['drag']);
  });
}
