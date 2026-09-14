import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../model/delete_marketplace_response_model.dart';

final class DeleteMarketplaceApi {
  static final DeleteMarketplaceApi _singleton =
      DeleteMarketplaceApi._internal();
  DeleteMarketplaceApi._internal();
  static DeleteMarketplaceApi get instance => _singleton;

  Future<DeleteMarketplaceResponseModel> deleteMarketplace(String id) async {
    try {
      Response response = await deleteHttp(Endpoints.marketplaceDetails(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteMarketplaceResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
