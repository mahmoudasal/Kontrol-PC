import '../../../../core/result/api_result.dart';
import '../repos/server_repository.dart';

class SetRequireApprovalUseCase {
  final ServerRepository _repository;

  SetRequireApprovalUseCase(this._repository);

  Future<ApiResult<void>> call(bool value) =>
      _repository.setRequireApproval(value);
}
