import '../../../../core/result/api_result.dart';
import '../entities/pairing_code.dart';

abstract class PairingRepository {
  /// The live code, or a fresh one if none exists or it expired.
  Future<ApiResult<PairingCode>> getCode();

  /// Invalidates the live code and issues a new one.
  Future<ApiResult<PairingCode>> regenerate();
}
