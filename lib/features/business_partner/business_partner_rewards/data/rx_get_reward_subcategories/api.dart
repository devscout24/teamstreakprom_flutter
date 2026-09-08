import 'package:dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../../../../networks/dio/dio.dart';
import '../../model/reward_subcategory_model.dart';

final class GetRewardSubcategoriesApi {
  static final GetRewardSubcategoriesApi _singleton = GetRewardSubcategoriesApi._internal();
  GetRewardSubcategoriesApi._internal();
  static GetRewardSubcategoriesApi get instance => _singleton;

  Future<RewardSubcategoryResponse> getRewardSubcategories(String categoryId) async {
    try {
      Response response = await getHttp(Endpoints.rewardSubcategories(categoryId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return RewardSubcategoryResponse.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
