import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/reset_password_model.dart';
import 'api.dart';

final class ResetPasswordRx extends RxResponseInt<ResetPasswordModel> {
  final api = ResetPasswordApi.instance;

  ResetPasswordRx({required super.empty, required super.dataFetcher});

  ValueStream<ResetPasswordModel> get getResetPasswordData => dataFetcher.stream;

  Future<bool> resetPassword(Map<String, dynamic> data) async {
    try {
      ResetPasswordModel response = await api.resetPassword(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
