import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/resend_register_otp_model.dart';

final class ResendRegisterOtpApi {
  static final ResendRegisterOtpApi _singleton = ResendRegisterOtpApi._internal();
  ResendRegisterOtpApi._internal();
  static ResendRegisterOtpApi get instance => _singleton;

  Future<ResendRegisterOtpModel> resendOtp(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.resendRegisterOtp(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return ResendRegisterOtpModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
