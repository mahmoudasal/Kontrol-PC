import '../../../../core/result/api_result.dart';
import '../entities/host_info.dart';
import '../repos/server_repository.dart';

class GetHostInfoUseCase {
  final ServerRepository _repository;

  GetHostInfoUseCase(this._repository);

  Future<ApiResult<HostInfo>> call() => _repository.getHostInfo();
}
