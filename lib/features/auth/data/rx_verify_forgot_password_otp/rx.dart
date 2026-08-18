import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/verify_forgot_password_otp_model.dart';
import 'api.dart';

final class VerifyForgotPasswordOtpRx extends RxResponseInt<VerifyForgotPasswordOtpModel> {
  final api = VerifyForgotPasswordOtpApi.instance;

  VerifyForgotPasswordOtpRx({required super.empty, required super.dataFetcher});

  ValueStream<VerifyForgotPasswordOtpModel> get getVerifyOtpData => dataFetcher.stream;

  Future<bool> verifyOtp(Map<String, dynamic> data) async {
    try {
      VerifyForgotPasswordOtpModel response = await api.verifyOtp(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
