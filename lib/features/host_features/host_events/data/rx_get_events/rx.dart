import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/get_events_response_model.dart';
import 'api.dart';

final class GetEventsRx extends RxResponseInt<GetEventsResponseModel> {
  final api = GetEventsApi.instance;

  GetEventsRx({required super.empty, required super.dataFetcher});

  ValueStream<GetEventsResponseModel> get getGetEventsData =>
      dataFetcher.stream;

  Future<void> fetchEvents({String? hostId}) async {
    try {
      GetEventsResponseModel response = await api.getEvents(hostId: hostId);
      handleSuccessWithReturn(response);
    } catch (e) {
      handleErrorWithReturn(e);
    }
  }
}
