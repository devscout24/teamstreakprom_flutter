import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/order_details_response_model.dart';

final class GetOrderDetailsApi {
  static final GetOrderDetailsApi _singleton = GetOrderDetailsApi._internal();
  GetOrderDetailsApi._internal();
  static GetOrderDetailsApi get instance => _singleton;

  Future<OrderDetailsResponseModel> getOrderDetails(String id) async {
    try {
      Response response = await getHttp(Endpoints.eventOrderDetails(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderDetailsResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
