import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/cancel_event_order_response_model.dart';
import 'api.dart';

final class CancelEventOrderRx
    extends RxResponseInt<CancelEventOrderResponseModel> {
  final api = CancelEventOrderApi.instance;

  CancelEventOrderRx({required super.empty, required super.dataFetcher});

  ValueStream<CancelEventOrderResponseModel> get getCancelEventOrderData =>
      dataFetcher.stream;

  Future<CancelEventOrderResponseModel> cancelEventOrder(String orderId) async {
    try {
      CancelEventOrderResponseModel response =
          await api.cancelEventOrder(orderId);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
