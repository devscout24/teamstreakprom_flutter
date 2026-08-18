import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/verify_forgot_password_otp_model.dart';

final class VerifyForgotPasswordOtpApi {
  static final VerifyForgotPasswordOtpApi _singleton = VerifyForgotPasswordOtpApi._internal();
  VerifyForgotPasswordOtpApi._internal();
  static VerifyForgotPasswordOtpApi get instance => _singleton;

  Future<VerifyForgotPasswordOtpModel> verifyOtp(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.verifyForgotPasswordOtp(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return VerifyForgotPasswordOtpModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
