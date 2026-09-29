import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/stripe_checkout_session_response_model.dart';

final class CreateCheckoutSessionApi {
  static final CreateCheckoutSessionApi _singleton =
      CreateCheckoutSessionApi._internal();
  CreateCheckoutSessionApi._internal();
  static CreateCheckoutSessionApi get instance => _singleton;

  Future<StripeCheckoutSessionResponseModel> createCheckoutSession(
      dynamic data) async {
    try {
      Response response = await postHttp(
        Endpoints.createCheckoutSession(),
        data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return StripeCheckoutSessionResponseModel.fromJson(resData);
        }
        return StripeCheckoutSessionResponseModel.fromJson(
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
