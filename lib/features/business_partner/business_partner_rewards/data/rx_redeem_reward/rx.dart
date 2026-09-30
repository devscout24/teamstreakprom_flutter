import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/redeem_reward_model.dart';
import 'api.dart';

final class RedeemRewardRx extends RxResponseInt<RedeemRewardResponseModel> {
  final api = RedeemRewardApi.instance;

  RedeemRewardRx({required super.empty, required super.dataFetcher});

  ValueStream<RedeemRewardResponseModel> get getRedeemRewardData =>
      dataFetcher.stream;

  Future<RedeemRewardResponseModel> redeemReward(Map<String, dynamic> data) async {
    try {
      RedeemRewardResponseModel response = await api.redeemReward(data);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}

final redeemRewardRx = RedeemRewardRx(
  empty: RedeemRewardResponseModel(),
  dataFetcher: BehaviorSubject<RedeemRewardResponseModel>(),
);
