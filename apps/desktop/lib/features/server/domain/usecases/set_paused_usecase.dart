import '../../../../core/result/api_result.dart';
import '../repos/server_repository.dart';

class SetPausedUseCase {
  final ServerRepository _repository;

  SetPausedUseCase(this._repository);

  Future<ApiResult<void>> call(bool paused) => _repository.setPaused(paused);
}
