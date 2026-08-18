import 'package:dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../networks/dio/dio.dart';
import '../../model/reset_password_model.dart';

final class ResetPasswordApi {
  static final ResetPasswordApi _singleton = ResetPasswordApi._internal();
  ResetPasswordApi._internal();
  static ResetPasswordApi get instance => _singleton;

  Future<ResetPasswordModel> resetPassword(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(Endpoints.resetPassword(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        return ResetPasswordModel.fromJson(resData);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
