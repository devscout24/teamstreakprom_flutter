import 'package:dio/dio.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/networks/exception_handler/data_source.dart';
import '../../model/stripe_account_status_model.dart';

final class GetStripeAccountStatusApi {
  static final GetStripeAccountStatusApi _singleton =
      GetStripeAccountStatusApi._internal();
  GetStripeAccountStatusApi._internal();
  static GetStripeAccountStatusApi get instance => _singleton;

  Future<StripeAccountStatusModel> getStripeAccountStatus() async {
    try {
      Response response = await getHttp(Endpoints.getStripeAccountStatus());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return StripeAccountStatusModel.fromJson(resData);
        }
        return StripeAccountStatusModel.fromJson(
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
