import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/user_profile_model.dart';

class UserProfileApi {
  static final UserProfileApi _singleton = UserProfileApi._internal();

  UserProfileApi._internal();

  static UserProfileApi get instance => _singleton;

  Future<UserProfileModel> fetchUserProfile() async {
    try {
      Response response = await getHttp(Endpoints.authMe());
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch user profile");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfileModel> updateProfile(dynamic data) async {
    try {
      Response response;
      try {
        response = await patchHttp(Endpoints.updateProfile(), data);
      } on DioException catch (dioErr) {
        if (dioErr.response?.statusCode == 405 ||
            dioErr.response?.statusCode == 404) {
          response = await putHttp(Endpoints.updateProfile(), data);
        } else {
          rethrow;
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception("Failed to update user profile");
      }
    } catch (e) {
      rethrow;
    }
  }
}
