import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/reward_subcategory_model.dart';
import 'api.dart';

final class GetRewardSubcategoriesRx extends RxResponseInt<RewardSubcategoryResponse> {
  final api = GetRewardSubcategoriesApi.instance;

  GetRewardSubcategoriesRx({required super.empty, required super.dataFetcher});

  ValueStream<RewardSubcategoryResponse> get getRewardSubcategoriesData => dataFetcher.stream;

  Future<void> getRewardSubcategories(String categoryId) async {
    try {
      // Show loading state by clearing previous data or just add a new empty instance?
      // Since RxResponseInt doesn't have a built-in loading state other than empty, 
      // we can choose to leave it as is or clear it.
      dataFetcher.sink.add(empty);
      RewardSubcategoryResponse response = await api.getRewardSubcategories(categoryId);
      handleSuccessWithReturn(response);
    } catch (e) {
      handleErrorWithReturn(e);
    }
  }
}

final getRewardSubcategoriesRx = GetRewardSubcategoriesRx(
  empty: RewardSubcategoryResponse(),
  dataFetcher: BehaviorSubject<RewardSubcategoryResponse>(),
);
