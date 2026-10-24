import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/change_password_response_model.dart';
import 'api.dart';

final class ChangePasswordRx
    extends RxResponseInt<ChangePasswordResponseModel> {
  final api = ChangePasswordApi.instance;

  ChangePasswordRx({required super.empty, required super.dataFetcher});

  ValueStream<ChangePasswordResponseModel> get changePasswordData =>
      dataFetcher.stream;

  Future<ChangePasswordResponseModel> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      ChangePasswordResponseModel response = await api.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
