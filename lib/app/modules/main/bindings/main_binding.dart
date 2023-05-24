import 'package:get/get.dart';

import 'package:emulator/app/modules/main/controllers/custom_acc_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_batt_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_beacon_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_bluetooth_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_compass_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_gyro_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_map_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_mic_controller.dart';
import 'package:emulator/app/modules/main/controllers/customcamera_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomBluetoothController>(
      () => CustomBluetoothController(),
    );
    Get.lazyPut<CustomBeaconController>(
      () => CustomBeaconController(),
    );
    Get.lazyPut<CustomBattController>(
      () => CustomBattController(),
    );
    Get.lazyPut<CustomAccController>(
      () => CustomAccController(),
    );
    Get.lazyPut<CustomGyroController>(
      () => CustomGyroController(),
    );
    Get.lazyPut<CustomCompassController>(
      () => CustomCompassController(),
    );
    Get.lazyPut<CustomMicController>(
      () => CustomMicController(),
    );
    Get.put<CustomMapController>(
      CustomMapController(),
    );

    Get.lazyPut<CustomcameraController>(
      () => CustomcameraController(),
    );

    Get.put<MainController>(
      MainController(),
    );
  }
}
