import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/ticket_messages_model.dart';

final class SendTicketMessageApi {
  static final SendTicketMessageApi _singleton =
      SendTicketMessageApi._internal();
  SendTicketMessageApi._internal();
  static SendTicketMessageApi get instance => _singleton;

  Future<SendTicketMessageResponseModel> sendTicketMessage({
    required String ticketId,
    required String message,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'message': message,
      };

      Response response = await postHttp(
        Endpoints.ticketMessages(ticketId),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return SendTicketMessageResponseModel.fromJson(resData);
        }
        return SendTicketMessageResponseModel.fromJson(
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
