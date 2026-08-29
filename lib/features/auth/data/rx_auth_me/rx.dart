import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/auth_me_model.dart';
import 'api.dart';

final class AuthMeRx extends RxResponseInt<AuthMeModel> {
  final api = AuthMeApi.instance;

  AuthMeRx({required super.empty, required super.dataFetcher});

  ValueStream<AuthMeModel> get authMeData => dataFetcher.stream;

  Future<void> fetchAuthMe() async {
    try {
      AuthMeModel response = await api.fetchAuthMe();
      handleSuccessWithReturn(response);
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
