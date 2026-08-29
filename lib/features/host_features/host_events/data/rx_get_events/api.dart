import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/get_events_response_model.dart';

final class GetEventsApi {
  static final GetEventsApi _singleton = GetEventsApi._internal();
  GetEventsApi._internal();
  static GetEventsApi get instance => _singleton;

  Future<GetEventsResponseModel> getEvents({String? hostId}) async {
    try {
      Response response = await getHttp(Endpoints.getEvents(hostId: hostId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetEventsResponseModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
