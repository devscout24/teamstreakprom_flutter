import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/my_reward_orders_response_model.dart';

final class GetMyRewardOrdersApi {
  static final GetMyRewardOrdersApi _singleton =
      GetMyRewardOrdersApi._internal();
  GetMyRewardOrdersApi._internal();
  static GetMyRewardOrdersApi get instance => _singleton;

  Future<MyRewardOrdersResponseModel> getMyRewardOrders({
    int? page,
    int? limit,
    String? itemType,
    String? status,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.myRewardOrders(
          page: page,
          limit: limit,
          itemType: itemType,
          status: status,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MyRewardOrdersResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
