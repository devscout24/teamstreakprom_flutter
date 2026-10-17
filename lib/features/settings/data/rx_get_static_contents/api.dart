import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/static_content_model.dart';

class GetStaticContentsApi {
  static final GetStaticContentsApi _singleton =
      GetStaticContentsApi._internal();

  GetStaticContentsApi._internal();

  static GetStaticContentsApi get instance => _singleton;

  Future<StaticContentModel> fetchStaticContents({
    String? category,
    String? slug,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.staticContents(category: category, slug: slug),
      );
      if (response.statusCode == 200) {
        return StaticContentModel.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch static contents");
      }
    } catch (e) {
      rethrow;
    }
  }
}
