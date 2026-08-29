import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/create_event_response_model.dart';

final class CreateEventApi {
  static final CreateEventApi _singleton = CreateEventApi._internal();
  CreateEventApi._internal();
  static CreateEventApi get instance => _singleton;

  Future<CreateEventResponseModel> createEvent(
    dynamic data,
  ) async {
    try {
      Response response = await postHttp(Endpoints.createEvent(), data);

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
