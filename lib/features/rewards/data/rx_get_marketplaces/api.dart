import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/get_marketplaces_model.dart';

final class GetMarketplacesApi {
  static final GetMarketplacesApi _singleton = GetMarketplacesApi._internal();
  GetMarketplacesApi._internal();
  static GetMarketplacesApi get instance => _singleton;

  Future<GetMarketplacesModel> getMarketplaces({
    int? page,
    int? limit,
  }) async {
    try {
      String path = Endpoints.marketplaces();
      final Map<String, String> queryParams = {};
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (queryParams.isNotEmpty) {
        path = "$path?${Uri(queryParameters: queryParams).query}";
      }

      Response response = await getHttp(path);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetMarketplacesModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
