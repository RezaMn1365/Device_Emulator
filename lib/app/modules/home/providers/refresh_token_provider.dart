import 'package:get/get.dart';

import '../refresh_token_model.dart';

class RefreshTokenProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return RefreshToken.fromJson(map);
      if (map is List)
        return map.map((item) => RefreshToken.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<RefreshToken?> getRefreshToken(int id) async {
    final response = await get('refreshtoken/$id');
    return response.body;
  }

  Future<Response<RefreshToken>> postRefreshToken(
          RefreshToken refreshtoken) async =>
      await post('refreshtoken', refreshtoken);
  Future<Response> deleteRefreshToken(int id) async =>
      await delete('refreshtoken/$id');
}
