import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/stripe_connect_response_model.dart';

final class CreateStripeConnectApi {
  static final CreateStripeConnectApi _singleton =
      CreateStripeConnectApi._internal();
  CreateStripeConnectApi._internal();
  static CreateStripeConnectApi get instance => _singleton;

  Future<StripeConnectResponseModel> createConnectAccount({
    String refreshUrl = "https://yourfrontend.com/host/stripe/refresh",
    String returnUrl = "https://yourfrontend.com/host/stripe/return",
    String country = "US",
    String businessType = "individual",
  }) async {
    try {
      final data = {
        "refreshUrl": refreshUrl,
        "returnUrl": returnUrl,
        "country": country,
        "businessType": businessType,
      };

      Response response = await postHttp(
        Endpoints.createStripeConnectAccount(),
        data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return StripeConnectResponseModel.fromJson(resData);
        } else if (resData is String) {
          return StripeConnectResponseModel.fromRawJson(resData);
        }
        return StripeConnectResponseModel.fromJson(
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
