import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/delete_event_response_model.dart';

final class DeleteEventApi {
  static final DeleteEventApi _singleton = DeleteEventApi._internal();
  DeleteEventApi._internal();
  static DeleteEventApi get instance => _singleton;

  Future<DeleteEventResponseModel> deleteEvent(String id) async {
    try {
      Response response = await deleteHttp(Endpoints.deleteEvent(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteEventResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
