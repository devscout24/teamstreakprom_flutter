import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/intrest_category_model.dart';
import 'api.dart';

final class GetSubCategoriesRx extends RxResponseInt<IntrestCategoryModel> {
  final api = GetSubCategoriesApi.instance;

  GetSubCategoriesRx({required super.empty, required super.dataFetcher});

  ValueStream<IntrestCategoryModel> get getSubCategoriesData => dataFetcher.stream;

  Future<void> fetchSubCategories(String parentId) async {
    try {
      // Show loading state by pushing empty data before fetching
      dataFetcher.sink.add(empty);
      IntrestCategoryModel data = await api.getSubCategories(parentId);
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }
}
