import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/my_support_tickets_model.dart';
import 'api.dart';

final class GetMyTicketsRx extends RxResponseInt<MySupportTicketsModel> {
  final api = GetMyTicketsApi.instance;

  GetMyTicketsRx({required super.empty, required super.dataFetcher});

  ValueStream<MySupportTicketsModel> get getMyTicketsData => dataFetcher.stream;

  Future<MySupportTicketsModel> fetchMyTickets({
    int? page,
    int? limit,
    String? status,
    String? search,
  }) async {
    try {
      MySupportTicketsModel response = await api.fetchMyTickets(
        page: page,
        limit: limit,
        status: status,
        search: search,
      );
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
