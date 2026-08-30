import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/create_event_response_model.dart';

final class UpdateEventApi {
  static final UpdateEventApi _singleton = UpdateEventApi._internal();
  UpdateEventApi._internal();
  static UpdateEventApi get instance => _singleton;

  Future<CreateEventResponseModel> updateEvent(
    String id,
    dynamic data,
  ) async {
    try {
      // Using patchHttp for update as requested
      Response response = await patchHttp(Endpoints.updateEvent(id), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateEventResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
