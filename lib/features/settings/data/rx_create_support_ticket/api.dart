import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/create_support_ticket_response_model.dart';

final class CreateSupportTicketApi {
  static final CreateSupportTicketApi _singleton =
      CreateSupportTicketApi._internal();
  CreateSupportTicketApi._internal();
  static CreateSupportTicketApi get instance => _singleton;

  Future<CreateSupportTicketResponseModel> createSupportTicket({
    required String title,
    required String description,
    String priority = 'MEDIUM',
  }) async {
    try {
      final Map<String, dynamic> body = {
        'title': title,
        'description': description,
        'priority': priority,
      };

      Response response = await postHttp(
        Endpoints.createSupportTicket(),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return CreateSupportTicketResponseModel.fromJson(resData);
        }
        return CreateSupportTicketResponseModel.fromJson(
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
