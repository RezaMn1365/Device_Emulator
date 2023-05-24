import 'package:emulator/app/modules/main/controllers/custom_beacon_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_file_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_gyro_controller.dart';
import 'package:get/get.dart';

import '../../main/controllers/custom_acc_controller.dart';
import '../../main/controllers/custom_map_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomBeaconController>(
      () => CustomBeaconController(),
    );
    Get.lazyPut<CustomFileController>(
      () => CustomFileController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CustomGyroController>(
      () => CustomGyroController(),
    );
    Get.lazyPut<CustomAccController>(
      () => CustomAccController(),
    );
  }
}
