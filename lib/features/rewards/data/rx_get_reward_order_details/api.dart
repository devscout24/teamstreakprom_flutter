import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/my_reward_order_details_model.dart';

final class GetRewardOrderDetailsApi {
  static final GetRewardOrderDetailsApi _singleton =
      GetRewardOrderDetailsApi._internal();
  GetRewardOrderDetailsApi._internal();
  static GetRewardOrderDetailsApi get instance => _singleton;

  Future<MyRewardOrderDetailsModel> getRewardOrderDetails(String id) async {
    try {
      Response response = await getHttp(Endpoints.rewardOrderDetails(id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MyRewardOrderDetailsModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
