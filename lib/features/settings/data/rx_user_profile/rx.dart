import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/user_profile_model.dart';
import 'api.dart';

final class UserProfileRx extends RxResponseInt<UserProfileModel> {
  final api = UserProfileApi.instance;

  UserProfileRx({required super.empty, required super.dataFetcher});

  ValueStream<UserProfileModel> get userProfileData => dataFetcher.stream;

  Future<void> fetchUserProfile() async {
    try {
      UserProfileModel response = await api.fetchUserProfile();
      handleSuccessWithReturn(response);
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }

  Future<UserProfileModel> updateProfile(dynamic data) async {
    try {
      UserProfileModel response = await api.updateProfile(data);
      handleSuccessWithReturn(response);
      return response;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
