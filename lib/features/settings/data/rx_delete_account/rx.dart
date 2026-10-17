import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/delete_account_response_model.dart';
import 'api.dart';

final class DeleteAccountRx extends RxResponseInt<DeleteAccountResponseModel> {
  final api = DeleteAccountApi.instance;

  DeleteAccountRx({required super.empty, required super.dataFetcher});

  ValueStream<DeleteAccountResponseModel> get getDeleteAccountData =>
      dataFetcher.stream;

  Future<bool> deleteAccount({
    bool hardDelete = false,
    String reason = "Closing account",
  }) async {
    try {
      DeleteAccountResponseModel response = await api.deleteAccount(
        hardDelete: hardDelete,
        reason: reason,
      );
      handleSuccessWithReturn(response);
      return response.success ?? true;
    } catch (e) {
      handleErrorWithReturn(e);
      return false;
    }
  }
}
