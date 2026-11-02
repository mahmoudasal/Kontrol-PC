import '../../../../core/result/api_result.dart';
import '../entities/pairing_code.dart';
import '../repos/pairing_repository.dart';

class RegeneratePairingCodeUseCase {
  final PairingRepository _repository;

  RegeneratePairingCodeUseCase(this._repository);

  Future<ApiResult<PairingCode>> call() => _repository.regenerate();
}
