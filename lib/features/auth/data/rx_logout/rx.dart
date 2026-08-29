import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/logout_model.dart';
import 'api.dart';

final class LogOutRx extends RxResponseInt<LogoutModel> {
  final api = LogOutApi.instance;

  LogOutRx({required super.empty, required super.dataFetcher});

  ValueStream<LogoutModel> get getLogOutData => dataFetcher.stream;

  Future<bool> logOut() async {
    try {
      LogoutModel response = await api.logOut();
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
