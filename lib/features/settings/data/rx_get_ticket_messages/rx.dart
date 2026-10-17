import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/ticket_messages_model.dart';
import 'api.dart';

final class GetTicketMessagesRx
    extends RxResponseInt<TicketMessagesResponseModel> {
  final api = GetTicketMessagesApi.instance;

  GetTicketMessagesRx({required super.empty, required super.dataFetcher});

  ValueStream<TicketMessagesResponseModel> get getTicketMessagesData =>
      dataFetcher.stream;

  Future<TicketMessagesResponseModel> fetchTicketMessages(String id) async {
    try {
      TicketMessagesResponseModel response = await api.fetchTicketMessages(id);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
