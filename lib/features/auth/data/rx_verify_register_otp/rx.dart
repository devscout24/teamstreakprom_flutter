import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/verify_register_otp_model.dart';
import 'api.dart';

final class VerifyRegisterOtpRx extends RxResponseInt<VerifyRegisterOtpModel> {
  final api = VerifyRegisterOtpApi.instance;

  VerifyRegisterOtpRx({required super.empty, required super.dataFetcher});

  ValueStream<VerifyRegisterOtpModel> get getVerifyOtpData =>
      dataFetcher.stream;

  Future<bool> verifyOtp(Map<String, dynamic> data) async {
    try {
      VerifyRegisterOtpModel response = await api.verifyOtp(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
