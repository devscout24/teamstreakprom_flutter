import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../model/redeem_reward_model.dart';

final class RedeemRewardApi {
  static final RedeemRewardApi _singleton = RedeemRewardApi._internal();
  RedeemRewardApi._internal();
  static RedeemRewardApi get instance => _singleton;

  Future<RedeemRewardResponseModel> redeemReward(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.orders(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return RedeemRewardResponseModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
