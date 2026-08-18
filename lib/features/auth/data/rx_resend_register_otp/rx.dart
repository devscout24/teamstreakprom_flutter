import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/resend_register_otp_model.dart';
import 'api.dart';

final class ResendRegisterOtpRx extends RxResponseInt<ResendRegisterOtpModel> {
  final api = ResendRegisterOtpApi.instance;

  ResendRegisterOtpRx({required super.empty, required super.dataFetcher});

  ValueStream<ResendRegisterOtpModel> get getResendOtpData => dataFetcher.stream;

  Future<bool> resendOtp(Map<String, dynamic> data) async {
    try {
      ResendRegisterOtpModel response = await api.resendOtp(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
