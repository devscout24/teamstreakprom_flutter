import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/delete_account_response_model.dart';

final class DeleteAccountApi {
  static final DeleteAccountApi _singleton = DeleteAccountApi._internal();
  DeleteAccountApi._internal();
  static DeleteAccountApi get instance => _singleton;

  Future<DeleteAccountResponseModel> deleteAccount({
    bool hardDelete = false,
    String reason = "Closing account",
  }) async {
    try {
      final Map<String, dynamic> body = {
        "hardDelete": hardDelete,
        "reason": reason,
      };

      Response response;
      try {
        response = await deleteHttp(Endpoints.deleteAccount(), body);
      } on DioException catch (e) {
        if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
          response = await postHttp(Endpoints.deleteAccount(), body);
        } else {
          rethrow;
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          return DeleteAccountResponseModel.fromJson(resData);
        }
        return DeleteAccountResponseModel(success: true);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
