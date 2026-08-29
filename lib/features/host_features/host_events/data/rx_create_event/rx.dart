import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/create_event_response_model.dart';
import 'api.dart';

final class CreateEventRx extends RxResponseInt<CreateEventResponseModel> {
  final api = CreateEventApi.instance;

  CreateEventRx({required super.empty, required super.dataFetcher});

  ValueStream<CreateEventResponseModel> get getCreateEventData =>
      dataFetcher.stream;

  Future<bool> createEvent(dynamic data) async {
    try {
      CreateEventResponseModel response = await api.createEvent(data);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
