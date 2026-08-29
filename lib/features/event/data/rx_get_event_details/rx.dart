import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/host_event_details_model.dart';
import 'api.dart';

final class GetEventDetailsRx extends RxResponseInt<HostEventDetailsModel> {
  final api = GetEventDetailsApi.instance;

  GetEventDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<HostEventDetailsModel> get getEventDetailsData =>
      dataFetcher.stream;

  Future<HostEventDetailsModel> getEventDetails(String id) async {
    try {
      HostEventDetailsModel response = await api.getEventDetails(id);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
