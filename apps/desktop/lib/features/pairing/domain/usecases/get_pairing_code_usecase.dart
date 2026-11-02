import '../../../../core/result/api_result.dart';
import '../entities/pairing_code.dart';
import '../repos/pairing_repository.dart';

class GetPairingCodeUseCase {
  final PairingRepository _repository;

  GetPairingCodeUseCase(this._repository);

  Future<ApiResult<PairingCode>> call() => _repository.getCode();
}
