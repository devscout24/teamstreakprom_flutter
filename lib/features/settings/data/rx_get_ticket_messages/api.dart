import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/ticket_messages_model.dart';

final class GetTicketMessagesApi {
  static final GetTicketMessagesApi _singleton =
      GetTicketMessagesApi._internal();
  GetTicketMessagesApi._internal();
  static GetTicketMessagesApi get instance => _singleton;

  Future<TicketMessagesResponseModel> fetchTicketMessages(String id) async {
    try {
      Response response = await getHttp(Endpoints.ticketMessages(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return TicketMessagesResponseModel.fromJson(resData);
        }
        return TicketMessagesResponseModel.fromJson(
          Map<String, dynamic>.from(resData as Map),
        );
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
