import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/event_fetch_by_category_model.dart';
import 'api.dart';

final class GetEventsByCategoryRx
    extends RxResponseInt<EventFetchByCategoryModel> {
  final api = GetEventsByCategoryApi.instance;

  GetEventsByCategoryRx({required super.empty, required super.dataFetcher});

  ValueStream<EventFetchByCategoryModel> get getEventsData =>
      dataFetcher.stream;

  String? currentCategoryId;
  String? currentSearch;

  Future<void> fetchEvents({
    int? page,
    int? limit,
    String? search,
    String? subCategoryId,
    String? categoryId,
    String? hostId,
    double? latitude,
    double? longitude,
    String? seed,
    String? date,
    num? minPrice,
    num? maxPrice,
    String? ticketAvailability,
    bool? rewardsAvailable,
  }) async {
    try {
      if (page == null || page == 1) {
        currentCategoryId = categoryId;
        currentSearch = search;
      }

      EventFetchByCategoryModel response = await api.getEvents(
        page: page,
        limit: limit,
        search: search ?? currentSearch,
        subCategoryId: subCategoryId,
        categoryId: categoryId ?? currentCategoryId,
        hostId: hostId,
        latitude: latitude,
        longitude: longitude,
        seed: seed,
        date: date,
        minPrice: minPrice,
        maxPrice: maxPrice,
        ticketAvailability: ticketAvailability,
        rewardsAvailable: rewardsAvailable,
      );

      if (page != null && page > 1 && dataFetcher.hasValue) {
        final currentData = dataFetcher.value;
        if (currentData.data != null && response.data != null) {
          response.data = [...currentData.data!, ...response.data!];
        }
      }

      handleSuccessWithReturn(response);
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
