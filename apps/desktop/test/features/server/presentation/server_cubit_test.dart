import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/core/error/failures.dart';
import 'package:kontrol_desktop/core/result/api_result.dart';
import 'package:kontrol_desktop/features/server/domain/entities/server_controls.dart';
import 'package:kontrol_desktop/features/server/domain/usecases/get_host_info_usecase.dart';
import 'package:kontrol_desktop/features/server/domain/usecases/get_server_controls_usecase.dart';
import 'package:kontrol_desktop/features/server/domain/usecases/set_paused_usecase.dart';
import 'package:kontrol_desktop/features/server/domain/usecases/set_require_approval_usecase.dart';
import 'package:kontrol_desktop/features/server/presentation/cubit/server_cubit.dart';
import 'package:kontrol_desktop/features/server/presentation/cubit/server_state.dart';

import '../fake_server_repository.dart';

ServerCubit buildServerCubit(FakeServerRepository repo) => ServerCubit(
  GetHostInfoUseCase(repo),
  GetServerControlsUseCase(repo),
  SetPausedUseCase(repo),
  SetRequireApprovalUseCase(repo),
);

const _ready = ServerControls(paused: false, requireApproval: true);

void main() {
  late FakeServerRepository repo;
  late ServerCubit cubit;

  setUp(() {
    repo = FakeServerRepository();
    cubit = buildServerCubit(repo);
  });

  tearDown(() => cubit.close());

  test('initial state is ServerLoading', () {
    expect(cubit.state, const ServerLoading());
  });

  test('load emits ServerRunning with host and controls', () async {
    await cubit.load();
    expect(cubit.state, const ServerRunning(sampleHost, _ready));
  });

  test('load emits ServerFailed when host info fails', () async {
    repo.hostResult = const ApiError(NetworkFailure('x'));
    await cubit.load();
    expect(cubit.state, isA<ServerFailed>());
  });

  test('togglePaused flips paused', () async {
    await cubit.load();
    await cubit.togglePaused();
    expect(
      cubit.state,
      ServerRunning(sampleHost, _ready.copyWith(paused: true)),
    );
  });

  test('setRequireApproval updates the controls', () async {
    await cubit.load();
    await cubit.setRequireApproval(false);
    expect(
      cubit.state,
      ServerRunning(sampleHost, _ready.copyWith(requireApproval: false)),
    );
  });

  test(
    'failed write emits ActionFailed then restores the old controls',
    () async {
      await cubit.load();
      repo.failWrites = true;
      final states = <ServerState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.setRequireApproval(false);
      await pumpEventQueue();
      await sub.cancel();

      expect(states, [
        isA<ServerActionFailed>(),
        const ServerRunning(sampleHost, _ready),
      ]);
    },
  );

  test('overlapping writes keep both changes', () async {
    await cubit.load();
    await Future.wait([cubit.togglePaused(), cubit.setRequireApproval(false)]);
    expect(
      cubit.state,
      const ServerRunning(
        sampleHost,
        ServerControls(paused: true, requireApproval: false),
      ),
    );
  });

  test('toggles are ignored before the server runs', () async {
    await cubit.togglePaused();
    expect(cubit.state, const ServerLoading());
  });
}
