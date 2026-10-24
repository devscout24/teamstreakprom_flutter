import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/change_password_response_model.dart';

final class ChangePasswordApi {
  static final ChangePasswordApi _singleton = ChangePasswordApi._internal();
  ChangePasswordApi._internal();
  static ChangePasswordApi get instance => _singleton;

  Future<ChangePasswordResponseModel> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      Response response;
      try {
        response = await postHttp(Endpoints.changePassword(), body);
      } on DioException catch (e) {
        if (e.response?.statusCode == 405) {
          response = await patchHttp(Endpoints.changePassword(), body);
        } else {
          rethrow;
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return ChangePasswordResponseModel.fromJson(resData);
        }
        return ChangePasswordResponseModel.fromJson(
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
