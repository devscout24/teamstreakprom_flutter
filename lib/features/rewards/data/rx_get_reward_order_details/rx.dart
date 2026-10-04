import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/my_reward_order_details_model.dart';
import 'api.dart';

final class GetRewardOrderDetailsRx
    extends RxResponseInt<MyRewardOrderDetailsModel> {
  final api = GetRewardOrderDetailsApi.instance;

  GetRewardOrderDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<MyRewardOrderDetailsModel> get getRewardOrderDetailsData =>
      dataFetcher.stream;

  Future<MyRewardOrderDetailsModel> fetchRewardOrderDetails(String id) async {
    try {
      MyRewardOrderDetailsModel response =
          await api.getRewardOrderDetails(id);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
