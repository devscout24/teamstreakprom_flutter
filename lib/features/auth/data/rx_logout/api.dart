import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/logout_model.dart';

final class LogOutApi {
  static final LogOutApi _singleton = LogOutApi._internal();
  LogOutApi._internal();
  static LogOutApi get instance => _singleton;

  Future<LogoutModel> logOut() async {
    try {
      Response response = await postHttp(Endpoints.logOut());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return LogoutModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
