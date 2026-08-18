import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/forgot_password_model.dart';

final class ForgotPasswordApi {
  static final ForgotPasswordApi _singleton = ForgotPasswordApi._internal();
  ForgotPasswordApi._internal();
  static ForgotPasswordApi get instance => _singleton;

  Future<ForgotPasswordModel> forgotPassword(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.forgotPassword(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return ForgotPasswordModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
