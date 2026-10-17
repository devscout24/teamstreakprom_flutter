import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/my_support_tickets_model.dart';

final class GetMyTicketsApi {
  static final GetMyTicketsApi _singleton = GetMyTicketsApi._internal();
  GetMyTicketsApi._internal();
  static GetMyTicketsApi get instance => _singleton;

  Future<MySupportTicketsModel> fetchMyTickets({
    int? page,
    int? limit,
    String? status,
    String? search,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.mySupportTickets(
          page: page,
          limit: limit,
          status: status,
          search: search,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return MySupportTicketsModel.fromJson(resData);
        }
        return MySupportTicketsModel.fromJson(
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
