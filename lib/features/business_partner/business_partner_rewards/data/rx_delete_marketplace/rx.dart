import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/delete_marketplace_response_model.dart';
import 'api.dart';

final class DeleteMarketplaceRx
    extends RxResponseInt<DeleteMarketplaceResponseModel> {
  final api = DeleteMarketplaceApi.instance;

  DeleteMarketplaceRx({required super.empty, required super.dataFetcher});

  ValueStream<DeleteMarketplaceResponseModel> get getDeleteMarketplaceData =>
      dataFetcher.stream;

  Future<DeleteMarketplaceResponseModel> deleteMarketplace(String id) async {
    try {
      DeleteMarketplaceResponseModel response = await api.deleteMarketplace(id);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
