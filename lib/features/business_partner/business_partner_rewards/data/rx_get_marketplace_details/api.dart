import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../model/get_marketplace_details_model.dart';

final class GetMarketplaceDetailsApi {
  static final GetMarketplaceDetailsApi _singleton =
      GetMarketplaceDetailsApi._internal();
  GetMarketplaceDetailsApi._internal();
  static GetMarketplaceDetailsApi get instance => _singleton;

  Future<GetMarketplaceDetailsModel> getMarketplaceDetails(String id) async {
    try {
      Response response = await getHttp(Endpoints.marketplaceDetails(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetMarketplaceDetailsModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
