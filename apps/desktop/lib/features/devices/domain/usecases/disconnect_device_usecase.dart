import '../../../../core/result/api_result.dart';
import '../repos/devices_repository.dart';

class DisconnectDeviceUseCase {
  final DevicesRepository _repository;

  DisconnectDeviceUseCase(this._repository);

  Future<ApiResult<void>> call(String id) => _repository.disconnect(id);
}
