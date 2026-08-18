import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/verify_register_otp_model.dart';

final class VerifyRegisterOtpApi {
  static final VerifyRegisterOtpApi _singleton = VerifyRegisterOtpApi._internal();
  VerifyRegisterOtpApi._internal();
  static VerifyRegisterOtpApi get instance => _singleton;

  Future<VerifyRegisterOtpModel> verifyOtp(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.verifyRegisterOtp(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return VerifyRegisterOtpModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
