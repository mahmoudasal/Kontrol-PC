import '../../../../core/result/api_result.dart';
import '../entities/server_controls.dart';
import '../repos/server_repository.dart';

class GetServerControlsUseCase {
  final ServerRepository _repository;

  GetServerControlsUseCase(this._repository);

  Future<ApiResult<ServerControls>> call() => _repository.getControls();
}
