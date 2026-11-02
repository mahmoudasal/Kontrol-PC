import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/core/error/failures.dart';
import 'package:kontrol_mobile/core/result/api_result.dart';
import 'package:kontrol_mobile/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:kontrol_mobile/features/onboarding/data/repos/onboarding_repository_impl.dart';

class _FakeDataSource implements OnboardingLocalDataSource {
  final bool completed;
  final bool shouldThrow;

  _FakeDataSource({this.completed = false, this.shouldThrow = false});

  @override
  Future<bool> isCompleted() async {
    if (shouldThrow) throw StateError('boom');
    return completed;
  }

  @override
  Future<void> markCompleted() async {
    if (shouldThrow) throw StateError('boom');
  }
}

void main() {
  test('isCompleted maps value to ApiSuccess', () async {
    final repo = OnboardingRepositoryImpl(_FakeDataSource(completed: true));

    final result = await repo.isCompleted();

    expect(result, isA<ApiSuccess<bool>>());
    expect((result as ApiSuccess<bool>).data, isTrue);
  });

  test('markCompleted maps success to ApiSuccess', () async {
    final repo = OnboardingRepositoryImpl(_FakeDataSource());

    expect(await repo.markCompleted(), isA<ApiSuccess<void>>());
  });

  test('isCompleted maps exception to CacheFailure', () async {
    final repo = OnboardingRepositoryImpl(_FakeDataSource(shouldThrow: true));

    final result = await repo.isCompleted();

    expect(result, isA<ApiError<bool>>());
    expect((result as ApiError<bool>).failure, isA<CacheFailure>());
  });

  test('markCompleted maps exception to CacheFailure', () async {
    final repo = OnboardingRepositoryImpl(_FakeDataSource(shouldThrow: true));

    final result = await repo.markCompleted();

    expect(result, isA<ApiError<void>>());
    expect((result as ApiError<void>).failure, isA<CacheFailure>());
  });
}
