import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/create_event_response_model.dart';
import 'api.dart';

final class UpdateEventRx extends RxResponseInt<CreateEventResponseModel> {
  final api = UpdateEventApi.instance;

  UpdateEventRx({required super.empty, required super.dataFetcher});

  ValueStream<CreateEventResponseModel> get getUpdateEventData =>
      dataFetcher.stream;

  Future<bool> updateEvent(String id, dynamic data) async {
    try {
      CreateEventResponseModel response = await api.updateEvent(id, data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
