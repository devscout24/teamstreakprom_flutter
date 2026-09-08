import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../model/reward_category_model.dart';
import 'api.dart';

final class GetRewardCategoriesRx extends RxResponseInt<RewardCategoryResponse> {
  final api = GetRewardCategoriesApi.instance;

  GetRewardCategoriesRx({required super.empty, required super.dataFetcher});

  ValueStream<RewardCategoryResponse> get getRewardCategoriesData => dataFetcher.stream;

  Future<void> getRewardCategories() async {
    try {
      RewardCategoryResponse response = await api.getRewardCategories();
      handleSuccessWithReturn(response);
    } catch (e) {
      handleErrorWithReturn(e);
    }
  }
}

final getRewardCategoriesRx = GetRewardCategoriesRx(
  empty: RewardCategoryResponse(),
  dataFetcher: BehaviorSubject<RewardCategoryResponse>(),
);
