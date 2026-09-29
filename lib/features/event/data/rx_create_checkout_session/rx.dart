import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/networks/rx_base.dart';
import '../../model/stripe_checkout_session_response_model.dart';
import 'api.dart';

final class CreateCheckoutSessionRx
    extends RxResponseInt<StripeCheckoutSessionResponseModel> {
  final api = CreateCheckoutSessionApi.instance;

  CreateCheckoutSessionRx({required super.empty, required super.dataFetcher});

  ValueStream<StripeCheckoutSessionResponseModel>
      get createCheckoutSessionData => dataFetcher.stream;

  Future<StripeCheckoutSessionResponseModel> createCheckoutSession(
      Map<String, dynamic> data) async {
    try {
      StripeCheckoutSessionResponseModel response =
          await api.createCheckoutSession(data);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
