import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/my_orders_response_model.dart';

final class GetMyOrdersApi {
  static final GetMyOrdersApi _singleton = GetMyOrdersApi._internal();
  GetMyOrdersApi._internal();
  static GetMyOrdersApi get instance => _singleton;

  Future<MyOrdersResponseModel> getMyOrders({
    int? page,
    int? limit,
    String? status,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.myOrders(
          page: page,
          limit: limit,
          status: status,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MyOrdersResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
