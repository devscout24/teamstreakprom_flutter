import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/forgot_password_model.dart';
import 'api.dart';

final class ForgotPasswordRx extends RxResponseInt<ForgotPasswordModel> {
  final api = ForgotPasswordApi.instance;

  ForgotPasswordRx({required super.empty, required super.dataFetcher});

  ValueStream<ForgotPasswordModel> get getForgotPasswordData => dataFetcher.stream;

  Future<bool> forgotPassword(Map<String, dynamic> data) async {
    try {
      ForgotPasswordModel response = await api.forgotPassword(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
