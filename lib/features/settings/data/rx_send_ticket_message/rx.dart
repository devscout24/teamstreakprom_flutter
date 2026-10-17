import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/ticket_messages_model.dart';
import 'api.dart';

final class SendTicketMessageRx
    extends RxResponseInt<SendTicketMessageResponseModel> {
  final api = SendTicketMessageApi.instance;

  SendTicketMessageRx({required super.empty, required super.dataFetcher});

  ValueStream<SendTicketMessageResponseModel> get sendTicketMessageData =>
      dataFetcher.stream;

  Future<SendTicketMessageResponseModel> sendTicketMessage({
    required String ticketId,
    required String message,
  }) async {
    try {
      SendTicketMessageResponseModel response = await api.sendTicketMessage(
        ticketId: ticketId,
        message: message,
      );
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
