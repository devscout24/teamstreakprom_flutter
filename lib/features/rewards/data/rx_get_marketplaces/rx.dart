import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/get_marketplaces_model.dart';
import 'api.dart';

final class GetMarketplacesRx extends RxResponseInt<GetMarketplacesModel> {
  final api = GetMarketplacesApi.instance;

  GetMarketplacesRx({required super.empty, required super.dataFetcher});

  ValueStream<GetMarketplacesModel> get getMarketplacesData =>
      dataFetcher.stream;

  Future<GetMarketplacesModel> fetchMarketplaces({
    int? page,
    int? limit,
  }) async {
    try {
      GetMarketplacesModel response = await api.getMarketplaces(
        page: page,
        limit: limit,
      );

      if (page != null && page > 1 && dataFetcher.hasValue) {
        final currentData = dataFetcher.value;
        if (currentData.data != null && response.data != null) {
          response.data = [...currentData.data!, ...response.data!];
        }
      }

      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
