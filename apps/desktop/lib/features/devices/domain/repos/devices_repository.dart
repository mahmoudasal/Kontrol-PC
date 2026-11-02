import '../../../../core/result/api_result.dart';
import '../entities/paired_device.dart';

abstract class DevicesRepository {
  /// Emits the current list, then every change.
  Stream<ApiResult<List<PairedDevice>>> watchDevices();

  /// Drops the live connection; the phone stays paired.
  Future<ApiResult<void>> disconnect(String id);

  /// Forgets the phone; it must pair again.
  Future<ApiResult<void>> revoke(String id);
}
