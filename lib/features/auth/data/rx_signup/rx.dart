import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import '../../../../networks/rx_base.dart';
import '../../model/user_signup_model.dart';
import 'api.dart';

final class SignUpRx extends RxResponseInt<UserSignupModel> {
  final api = SignUpApi.instance;

  SignUpRx({required super.empty, required super.dataFetcher});

  ValueStream<UserSignupModel> get getSignUpData => dataFetcher.stream;

  Future<bool> signUp(FormData formData) async {
    try {
      UserSignupModel response = await api.signUp(formData);
      handleSuccessWithReturn(response);
      return response.success ?? false;
    } catch (e) {
      handleErrorWithReturn(e);
      rethrow;
    }
  }
}
