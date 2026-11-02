import '../../../../core/result/api_result.dart';
import '../repos/devices_repository.dart';

class RevokeDeviceUseCase {
  final DevicesRepository _repository;

  RevokeDeviceUseCase(this._repository);

  Future<ApiResult<void>> call(String id) => _repository.revoke(id);
}
