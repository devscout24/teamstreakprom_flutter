import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/event_fetch_by_category_model.dart';

final class GetEventsByCategoryApi {
  static final GetEventsByCategoryApi _singleton = GetEventsByCategoryApi._internal();
  GetEventsByCategoryApi._internal();
  static GetEventsByCategoryApi get instance => _singleton;

  Future<EventFetchByCategoryModel> getEvents({
    int? page,
    int? limit,
    String? search,
    String? subCategoryId,
    String? categoryId,
    String? hostId,
    double? latitude,
    double? longitude,
    String? seed,
  }) async {
    try {
      String url = Endpoints.getEvents();
      
      final Map<String, String> queryParams = {};
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (subCategoryId != null && subCategoryId.isNotEmpty) queryParams['subCategoryId'] = subCategoryId;
      if (categoryId != null && categoryId.isNotEmpty && categoryId != "All") queryParams['categoryId'] = categoryId;
      if (hostId != null && hostId.isNotEmpty) queryParams['hostId'] = hostId;
      if (latitude != null) queryParams['latitude'] = latitude.toString();
      if (longitude != null) queryParams['longitude'] = longitude.toString();
      if (seed != null && seed.isNotEmpty) queryParams['seed'] = seed;

      if (queryParams.isNotEmpty) {
        final queryString = Uri(queryParameters: queryParams).query;
        // In endpoints.dart, getEvents might already have a '?hostId=xxx' if hostId is provided,
        // but we're calling Endpoints.getEvents() with no args here.
        if (url.contains('?')) {
          url = "$url&$queryString";
        } else {
          url = "$url?$queryString";
        }
      }
      
      Response response = await getHttp(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return EventFetchByCategoryModel.fromJson(data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
