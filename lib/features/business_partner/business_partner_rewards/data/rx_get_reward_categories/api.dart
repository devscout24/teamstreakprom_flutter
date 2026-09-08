import 'package:dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../../../../networks/dio/dio.dart';
import '../../model/reward_category_model.dart';

final class GetRewardCategoriesApi {
  static final GetRewardCategoriesApi _singleton = GetRewardCategoriesApi._internal();
  GetRewardCategoriesApi._internal();
  static GetRewardCategoriesApi get instance => _singleton;

  Future<RewardCategoryResponse> getRewardCategories() async {
    try {
      Response response = await getHttp(Endpoints.rewardCategories());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return RewardCategoryResponse.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
