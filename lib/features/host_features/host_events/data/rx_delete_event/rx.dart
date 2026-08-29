import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/delete_event_response_model.dart';
import 'api.dart';

final class DeleteEventRx extends RxResponseInt<DeleteEventResponseModel> {
  final api = DeleteEventApi.instance;

  DeleteEventRx({required super.empty, required super.dataFetcher});

  ValueStream<DeleteEventResponseModel> get getDeleteEventData =>
      dataFetcher.stream;

  Future<bool> deleteEvent(String id) async {
    try {
      DeleteEventResponseModel response = await api.deleteEvent(id);
      handleSuccessWithReturn(response);
      return response.success ?? true; // assume true if null and it didn't throw
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
