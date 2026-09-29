import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/order_details_response_model.dart';
import 'api.dart';

final class GetOrderDetailsRx
    extends RxResponseInt<OrderDetailsResponseModel> {
  final api = GetOrderDetailsApi.instance;

  GetOrderDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<OrderDetailsResponseModel> get getOrderDetailsData =>
      dataFetcher.stream;

  Future<OrderDetailsResponseModel> fetchOrderDetails(String id) async {
    try {
      OrderDetailsResponseModel response = await api.getOrderDetails(id);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
