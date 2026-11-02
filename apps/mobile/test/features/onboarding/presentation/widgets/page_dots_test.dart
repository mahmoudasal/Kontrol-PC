import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/widgets/page_dots.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../fake_onboarding_repository.dart';

void main() {
  testWidgets('only the current page dot is 24 wide', (tester) async {
    final cubit = OnboardingCubit(
      CompleteOnboardingUseCase(FakeOnboardingRepository()),
    );
    addTearDown(cubit.close);
    await tester.pumpWidget(
      MaterialApp(
        theme: KontrolTheme.dark(),
        home: Scaffold(
          body: BlocProvider.value(value: cubit, child: const PageDots()),
        ),
      ),
    );

    cubit.pageChanged(1);
    await tester.pumpAndSettle();

    final widths = [
      for (var i = 0; i < OnboardingCubit.pageCount; i++)
        tester.getSize(find.byType(AnimatedContainer).at(i)).width,
    ];
    expect(widths, [8, 24, 8]);
  });
}
