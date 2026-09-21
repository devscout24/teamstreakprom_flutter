import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/stripe_connect_response_model.dart';
import 'api.dart';

final class CreateStripeConnectRx
    extends RxResponseInt<StripeConnectResponseModel> {
  final api = CreateStripeConnectApi.instance;

  CreateStripeConnectRx({required super.empty, required super.dataFetcher});

  ValueStream<StripeConnectResponseModel> get getStripeConnectData =>
      dataFetcher.stream;

  Future<StripeConnectResponseModel?> createConnectAccount({
    String refreshUrl = "https://yourfrontend.com/host/stripe/refresh",
    String returnUrl = "https://yourfrontend.com/host/stripe/return",
    String country = "US",
    String businessType = "individual",
  }) async {
    try {
      StripeConnectResponseModel response = await api.createConnectAccount(
        refreshUrl: refreshUrl,
        returnUrl: returnUrl,
        country: country,
        businessType: businessType,
      );
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      return null;
    }
  }
}
