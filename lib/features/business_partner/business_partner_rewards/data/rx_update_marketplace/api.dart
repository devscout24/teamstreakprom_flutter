import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../model/marketplace_response_model.dart';

final class UpdateMarketplaceApi {
  static final UpdateMarketplaceApi _singleton =
      UpdateMarketplaceApi._internal();
  UpdateMarketplaceApi._internal();
  static UpdateMarketplaceApi get instance => _singleton;

  Future<MarketplaceResponseModel> updateMarketplace(
    String id,
    dynamic data,
  ) async {
    try {
      Response response;
      try {
        response = await patchHttp(Endpoints.marketplaceDetails(id), data);
      } on DioException catch (dioErr) {
        if (dioErr.response?.statusCode == 405 ||
            dioErr.response?.statusCode == 404) {
          response = await putHttp(Endpoints.marketplaceDetails(id), data);
        } else {
          rethrow;
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return MarketplaceResponseModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
