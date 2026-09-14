import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
import '../../model/my_marketplaces_response_model.dart';

final class GetMyMarketplacesApi {
  static final GetMyMarketplacesApi _singleton =
      GetMyMarketplacesApi._internal();
  GetMyMarketplacesApi._internal();
  static GetMyMarketplacesApi get instance => _singleton;

  Future<MyMarketplacesResponseModel> getMyMarketplaces() async {
    try {
      Response response = await getHttp(Endpoints.myMarketplaces());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MyMarketplacesResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
