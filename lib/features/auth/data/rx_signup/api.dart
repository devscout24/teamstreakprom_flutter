import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/user_signup_model.dart';

final class SignUpApi {
  static final SignUpApi _singleton = SignUpApi._internal();
  SignUpApi._internal();
  static SignUpApi get instance => _singleton;

  Future<UserSignupModel> signUp(FormData formData) async {
    try {
      Response response = await postHttp(Endpoints.signUp(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return UserSignupModel.fromJson(data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
