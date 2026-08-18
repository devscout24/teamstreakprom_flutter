import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/refresh_token_model.dart';
import 'api.dart';

final class RefreshTokenRx extends RxResponseInt<RefreshTokenModel> {
  final api = RefreshTokenApi.instance;

  RefreshTokenRx({required super.empty, required super.dataFetcher});

  ValueStream<RefreshTokenModel> get getRefreshTokenData => dataFetcher.stream;

  Future<bool> refreshToken(Map<String, dynamic> data) async {
    try {
      RefreshTokenModel response = await api.refreshToken(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
