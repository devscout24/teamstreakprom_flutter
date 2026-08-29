import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/intrest_category_model.dart';
import 'api.dart';

final class GetCategoriesRx extends RxResponseInt<IntrestCategoryModel> {
  final api = GetCategoriesApi.instance;

  GetCategoriesRx({required super.empty, required super.dataFetcher});

  ValueStream<IntrestCategoryModel> get getCategoriesData => dataFetcher.stream;

  Future<void> fetchCategories() async {
    try {
      IntrestCategoryModel response = await api.getCategories();
      handleSuccessWithReturn(response);
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
