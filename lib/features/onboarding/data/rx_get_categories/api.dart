import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/intrest_category_model.dart';

final class GetCategoriesApi {
  static final GetCategoriesApi _singleton = GetCategoriesApi._internal();
  GetCategoriesApi._internal();
  static GetCategoriesApi get instance => _singleton;

  Future<IntrestCategoryModel> getCategories() async {
    try {
      Response response = await getHttp(Endpoints.categories());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return IntrestCategoryModel.fromJson(data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
