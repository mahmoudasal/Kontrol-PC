import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../../../core/result/api_result.dart';
import '../../domain/entities/paired_device.dart';
import '../../domain/repos/devices_repository.dart';
import '../datasources/fake_devices_data_source.dart';

class DevicesRepositoryImpl implements DevicesRepository {
  final FakeDevicesDataSource _dataSource;

  DevicesRepositoryImpl(this._dataSource);

  @override
  Stream<ApiResult<List<PairedDevice>>> watchDevices() {
    return _dataSource.watch().transform(
      StreamTransformer.fromHandlers(
        handleData: (devices, sink) => sink.add(ApiSuccess(devices)),
        handleError: (_, _, sink) => sink.add(
          const ApiError(UnexpectedFailure('Could not load devices.')),
        ),
      ),
    );
  }

  @override
  Future<ApiResult<void>> disconnect(String id) async {
    try {
      _dataSource.disconnect(id);
      return const ApiSuccess(null);
    } catch (_) {
      return const ApiError(UnexpectedFailure('Could not disconnect.'));
    }
  }

  @override
  Future<ApiResult<void>> revoke(String id) async {
    try {
      _dataSource.revoke(id);
      return const ApiSuccess(null);
    } catch (_) {
      return const ApiError(UnexpectedFailure('Could not revoke.'));
    }
  }
}
