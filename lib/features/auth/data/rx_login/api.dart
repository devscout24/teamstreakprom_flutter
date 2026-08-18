import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/user_login_model.dart';

final class LogInApi {
  static final LogInApi _singleton = LogInApi._internal();
  LogInApi._internal();
  static LogInApi get instance => _singleton;

  Future<UserLoginModel> logIn(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.logIn(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return UserLoginModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
