import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/stripe_account_status_model.dart';
import 'api.dart';

final class GetStripeAccountStatusRx
    extends RxResponseInt<StripeAccountStatusModel> {
  final api = GetStripeAccountStatusApi.instance;

  GetStripeAccountStatusRx({required super.empty, required super.dataFetcher});

  ValueStream<StripeAccountStatusModel> get getStripeAccountStatusData =>
      dataFetcher.stream;

  Future<StripeAccountStatusModel> getStripeAccountStatus() async {
    try {
      StripeAccountStatusModel response = await api.getStripeAccountStatus();
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
