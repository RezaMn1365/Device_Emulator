import 'package:get/get.dart';

import '../authenticate_model.dart';

class AuthenticateProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Authenticate.fromJson(map);
      if (map is List)
        return map.map((item) => Authenticate.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Authenticate?> getAuthenticate(int id) async {
    final response = await get('authenticate/$id');
    return response.body;
  }

  Future<Response<Authenticate>> postAuthenticate(
          Authenticate authenticate) async =>
      await post('authenticate', authenticate);
  Future<Response> deleteAuthenticate(int id) async =>
      await delete('authenticate/$id');
}
