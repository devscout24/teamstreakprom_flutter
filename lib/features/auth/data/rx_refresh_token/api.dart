import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/refresh_token_model.dart';

final class RefreshTokenApi {
  static final RefreshTokenApi _singleton = RefreshTokenApi._internal();
  RefreshTokenApi._internal();
  static RefreshTokenApi get instance => _singleton;

  Future<RefreshTokenModel> refreshToken(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.refreshToken(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return RefreshTokenModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
