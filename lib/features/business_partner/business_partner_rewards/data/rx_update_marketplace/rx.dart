import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/marketplace_response_model.dart';
import 'api.dart';

final class UpdateMarketplaceRx
    extends RxResponseInt<MarketplaceResponseModel> {
  final api = UpdateMarketplaceApi.instance;

  UpdateMarketplaceRx({required super.empty, required super.dataFetcher});

  ValueStream<MarketplaceResponseModel> get getUpdateMarketplaceData =>
      dataFetcher.stream;

  Future<MarketplaceResponseModel> updateMarketplace(
    String id,
    dynamic data,
  ) async {
    try {
      MarketplaceResponseModel response =
          await api.updateMarketplace(id, data);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}

final updateMarketplaceRx = UpdateMarketplaceRx(
  empty: MarketplaceResponseModel(),
  dataFetcher: BehaviorSubject<MarketplaceResponseModel>(),
);
