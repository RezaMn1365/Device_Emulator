import 'package:get/get.dart';

import '../device_model.dart';

class DeviceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Device.fromJson(map);
      if (map is List) return map.map((item) => Device.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Device?> getDevice(int id) async {
    final response = await get('device/$id');
    return response.body;
  }

  Future<Response<Device>> postDevice(Device device) async =>
      await post('device', device);
  Future<Response> deleteDevice(int id) async => await delete('device/$id');
}
