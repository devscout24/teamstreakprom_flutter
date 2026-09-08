import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../model/marketplace_response_model.dart';

final class PostMarketplaceApi {
  static final PostMarketplaceApi _singleton = PostMarketplaceApi._internal();
  PostMarketplaceApi._internal();
  static PostMarketplaceApi get instance => _singleton;

  Future<MarketplaceResponseModel> postMarketplace(dynamic data) async {
    try {
      Response response = await postHttp(Endpoints.marketplaces(), data);

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
