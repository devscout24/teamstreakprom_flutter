import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/my_orders_response_model.dart';
import 'api.dart';

final class GetMyOrdersRx extends RxResponseInt<MyOrdersResponseModel> {
  final api = GetMyOrdersApi.instance;

  GetMyOrdersRx({required super.empty, required super.dataFetcher});

  ValueStream<MyOrdersResponseModel> get getMyOrdersData =>
      dataFetcher.stream;

  Future<MyOrdersResponseModel> fetchMyOrders({
    int? page,
    int? limit,
    String? status,
  }) async {
    try {
      MyOrdersResponseModel response = await api.getMyOrders(
        page: page,
        limit: limit,
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
