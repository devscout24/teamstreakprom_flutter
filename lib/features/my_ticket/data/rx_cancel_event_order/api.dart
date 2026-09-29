import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/cancel_event_order_response_model.dart';

final class CancelEventOrderApi {
  static final CancelEventOrderApi _singleton =
      CancelEventOrderApi._internal();
  CancelEventOrderApi._internal();
  static CancelEventOrderApi get instance => _singleton;

  Future<CancelEventOrderResponseModel> cancelEventOrder(String orderId) async {
    try {
      Response response = await postHttp(Endpoints.cancelEventOrder(orderId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return CancelEventOrderResponseModel.fromJson(resData);
        }
        return CancelEventOrderResponseModel.fromJson(
          Map<String, dynamic>.from(resData as Map),
        );
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
