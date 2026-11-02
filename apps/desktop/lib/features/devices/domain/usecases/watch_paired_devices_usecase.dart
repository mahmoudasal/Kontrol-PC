import '../../../../core/result/api_result.dart';
import '../entities/paired_device.dart';
import '../repos/devices_repository.dart';

class WatchPairedDevicesUseCase {
  final DevicesRepository _repository;

  WatchPairedDevicesUseCase(this._repository);

  Stream<ApiResult<List<PairedDevice>>> call() => _repository.watchDevices();
}
