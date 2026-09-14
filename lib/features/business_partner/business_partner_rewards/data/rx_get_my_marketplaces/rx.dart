import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/my_marketplaces_response_model.dart';
import 'api.dart';

final class GetMyMarketplacesRx
    extends RxResponseInt<MyMarketplacesResponseModel> {
  final api = GetMyMarketplacesApi.instance;

  GetMyMarketplacesRx({required super.empty, required super.dataFetcher});

  ValueStream<MyMarketplacesResponseModel> get getMyMarketplacesData =>
      dataFetcher.stream;

  Future<MyMarketplacesResponseModel> fetchMyMarketplaces() async {
    try {
      MyMarketplacesResponseModel response = await api.getMyMarketplaces();
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
