import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/user_login_model.dart';
import 'api.dart';

final class LogInRx extends RxResponseInt<UserLoginModel> {
  final api = LogInApi.instance;

  LogInRx({required super.empty, required super.dataFetcher});

  ValueStream<UserLoginModel> get getLogInData => dataFetcher.stream;

  Future<bool> logIn(Map<String, dynamic> data) async {
    try {
      UserLoginModel response = await api.logIn(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
