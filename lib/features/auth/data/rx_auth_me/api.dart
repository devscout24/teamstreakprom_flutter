import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/auth_me_model.dart';

final class AuthMeApi {
  static final AuthMeApi _singleton = AuthMeApi._internal();
  AuthMeApi._internal();
  static AuthMeApi get instance => _singleton;

  Future<AuthMeModel> fetchAuthMe() async {
    try {
      String url = Endpoints.authMe();
      Response response = await getHttp(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return AuthMeModel.fromJson(data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
