import '../../modules/home/device_model.dart';
import 'basic_api_response.dart';

abstract class HTTP {
  Future<bool> signInRequest(String url, Device deviceData);
}
