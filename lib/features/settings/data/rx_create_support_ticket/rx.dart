import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/create_support_ticket_response_model.dart';
import 'api.dart';

final class CreateSupportTicketRx
    extends RxResponseInt<CreateSupportTicketResponseModel> {
  final api = CreateSupportTicketApi.instance;

  CreateSupportTicketRx({required super.empty, required super.dataFetcher});

  ValueStream<CreateSupportTicketResponseModel> get createSupportTicketData =>
      dataFetcher.stream;

  Future<CreateSupportTicketResponseModel> createSupportTicket({
    required String title,
    required String description,
    String priority = 'MEDIUM',
  }) async {
    try {
      CreateSupportTicketResponseModel response =
          await api.createSupportTicket(
        title: title,
        description: description,
        priority: priority,
      );
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
