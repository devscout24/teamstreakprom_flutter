import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/marketplace_response_model.dart';
import 'api.dart';

final class PostMarketplaceRx extends RxResponseInt<MarketplaceResponseModel> {
  final api = PostMarketplaceApi.instance;

  PostMarketplaceRx({required super.empty, required super.dataFetcher});

  ValueStream<MarketplaceResponseModel> get getPostMarketplaceData =>
      dataFetcher.stream;

  Future<MarketplaceResponseModel> postMarketplace(dynamic data) async {
    try {
      MarketplaceResponseModel response = await api.postMarketplace(data);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}

final postMarketplaceRx = PostMarketplaceRx(
  empty: MarketplaceResponseModel(),
  dataFetcher: BehaviorSubject<MarketplaceResponseModel>(),
);
