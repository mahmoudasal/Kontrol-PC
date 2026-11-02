import '../../../../core/error/failures.dart';
import '../../../../core/result/api_result.dart';
import '../../domain/entities/pairing_code.dart';
import '../../domain/repos/pairing_repository.dart';
import '../datasources/fake_pairing_data_source.dart';

class PairingRepositoryImpl implements PairingRepository {
  final FakePairingDataSource _dataSource;

  PairingRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<PairingCode>> getCode() async {
    try {
      return ApiSuccess(_dataSource.getCode());
    } catch (_) {
      return const ApiError(UnexpectedFailure('Could not create a code.'));
    }
  }

  @override
  Future<ApiResult<PairingCode>> regenerate() async {
    try {
      return ApiSuccess(_dataSource.regenerate());
    } catch (_) {
      return const ApiError(UnexpectedFailure('Could not create a code.'));
    }
  }
}
