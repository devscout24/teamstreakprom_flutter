import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/static_content_model.dart';
import 'api.dart';

final class GetStaticContentsRx extends RxResponseInt<StaticContentModel> {
  final api = GetStaticContentsApi.instance;

  GetStaticContentsRx({required super.empty, required super.dataFetcher});

  ValueStream<StaticContentModel> get getStaticContentsData =>
      dataFetcher.stream;

  Future<StaticContentModel> fetchStaticContents({
    String? category,
    String? slug,
  }) async {
    try {
      StaticContentModel response = await api.fetchStaticContents(
        category: category,
        slug: slug,
      );
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
