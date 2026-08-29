import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/intrest_category_model.dart';

final class GetSubCategoriesApi {
  static final GetSubCategoriesApi _singleton = GetSubCategoriesApi._internal();
  GetSubCategoriesApi._internal();
  static GetSubCategoriesApi get instance => _singleton;

  Future<IntrestCategoryModel> getSubCategories(String parentId) async {
    try {
      Response response = await getHttp(Endpoints.subcategories(parentId));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return IntrestCategoryModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
