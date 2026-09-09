import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/get_marketplace_details_model.dart';
import 'api.dart';

final class GetMarketplaceDetailsRx
    extends RxResponseInt<GetMarketplaceDetailsModel> {
  final api = GetMarketplaceDetailsApi.instance;

  GetMarketplaceDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<GetMarketplaceDetailsModel> get getMarketplaceDetailsData =>
      dataFetcher.stream;

  Future<GetMarketplaceDetailsModel> fetchMarketplaceDetails(String id) async {
    try {
      GetMarketplaceDetailsModel response =
          await api.getMarketplaceDetails(id);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
