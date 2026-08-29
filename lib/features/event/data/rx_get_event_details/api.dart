import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/host_event_details_model.dart';

final class GetEventDetailsApi {
  static final GetEventDetailsApi _singleton = GetEventDetailsApi._internal();
  GetEventDetailsApi._internal();
  static GetEventDetailsApi get instance => _singleton;

  Future<HostEventDetailsModel> getEventDetails(String id) async {
    try {
      Response response = await getHttp(Endpoints.getEventDetails(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HostEventDetailsModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
