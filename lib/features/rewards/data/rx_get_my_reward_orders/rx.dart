import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/my_reward_orders_response_model.dart';
import 'api.dart';

final class GetMyRewardOrdersRx
    extends RxResponseInt<MyRewardOrdersResponseModel> {
  final api = GetMyRewardOrdersApi.instance;

  GetMyRewardOrdersRx({required super.empty, required super.dataFetcher});

  ValueStream<MyRewardOrdersResponseModel> get getMyRewardOrdersData =>
      dataFetcher.stream;

  Future<MyRewardOrdersResponseModel> fetchMyRewardOrders({
    int? page,
    int? limit,
    String? itemType,
    String? status,
  }) async {
    try {
      MyRewardOrdersResponseModel response = await api.getMyRewardOrders(
        page: page,
        limit: limit,
        itemType: itemType,
        status: status,
      );

      if (page != null && page > 1 && dataFetcher.hasValue) {
        final currentData = dataFetcher.value;
        if (currentData.data != null) {
          final existingIds = currentData.data!
              .map((e) => e.id)
              .where((id) => id != null)
              .toSet();

          final newItems = (response.data ?? []).where((e) {
            if (e.id == null) return true;
            return !existingIds.contains(e.id);
          }).toList();

          response.data = [...currentData.data!, ...newItems];
        }
      }

      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
