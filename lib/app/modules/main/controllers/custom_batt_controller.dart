import 'dart:async';
import 'dart:convert';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:get/get.dart';

import 'custom_file_controller.dart';

class CustomBattController extends GetxController {
  var fileController = Get.find<CustomFileController>();

  late StreamSubscription<AndroidBatteryInfo?> batteryStream;
  AndroidBatteryInfo infoandroid = AndroidBatteryInfo();
  //IosBatteryInfo infoios = IosBatteryInfo(); use for iOS
  BatteryInfoPlugin batteryInfoPlugin = BatteryInfoPlugin();

  RxBool isRunning = false.obs;
  RxInt batteryPercentage = 0.obs;
  RxString batteryState = ''.obs;
  RxString batteryHealth = ''.obs;

  RxBool buttomEnable = true.obs;
  RxBool locked = false.obs;
  RxBool onOff = false.obs;
  RxBool blinking = false.obs;
  RxString buttomText = 'Deactive'.obs;
  void onPressed() async {
    await makeReportFile();
  }

  @override
  void onInit() {
    // batteryReader();
    super.onInit();
  }

  Future<void> startStream() async {
    if (!isRunning.value) {
      await start();
    }
  }

  Future<void> stopStream() async {
    if (isRunning.value) {
      await stop();
    }
  }

  Future<void> makeReportFile() async {
    var rawData = await getSample();
    var data = base64Encode(rawData.writeToBuffer()) + '\n';
    fileController.writeToFile('/data/sensor/battery/battery', data);
  }

  Future<ReportMessage> getSample() async {
    if (isRunning.value) {
      return ReportMessage(
        battery: Battery(
            charge: batteryPercentage.value,
            health: batteryHealth.value,
            status: batteryState.value),
      );
    } else {
      var result = await batteryInfoPlugin.androidBatteryInfoStream.first;

      if (result != null) {
        batteryPercentage.value = result.batteryLevel!;
        String finalStr = result.health!;
        batteryHealth.value = finalStr.replaceAll('health.', '');
        finalStr = result.chargingStatus.toString();
        batteryState.value = finalStr.replaceAll('ChargingStatus.', '');
      }
      return ReportMessage(
        battery: Battery(
            charge: batteryPercentage.value,
            health: batteryHealth.value,
            status: batteryState.value),
      );
    }
  }

  Future<void> start() async {
    buttomEnable.value = false;
    locked.value = true;
    onOff.value = true;
    blinking.value = true;
    buttomText.value = 'processing...';
    isRunning.value = true;
    await batteryReader();
  }

  Future<void> stop() async {
    buttomEnable.value = false;
    locked.value = false;
    onOff.value = false;
    blinking.value = false;
    buttomText.value = 'Press';
    isRunning.value = false;
    await batteryStream.cancel();
  }

  Future<void> batteryReader() async {
    Future.delayed(Duration.zero, () async {
      infoandroid = (await batteryInfoPlugin.androidBatteryInfo)!;
      // infoios = await BatteryInfoPlugin().iosBatteryInfo;  for iOS
      batteryPercentage.value = infoandroid.batteryLevel!;
      String finalStr = infoandroid.health!;
      batteryHealth.value = finalStr.replaceAll('health.', '');
      finalStr = infoandroid.chargingStatus.toString();
      batteryState.value = finalStr.replaceAll('ChargingStatus.', '');
    });

    batteryStream =
        batteryInfoPlugin.androidBatteryInfoStream.listen((batteryInfo) {
      //add listiner to update values if there is changes
      if (batteryInfo != null) {
        batteryPercentage.value = batteryInfo.batteryLevel!;
        String finalStr = batteryInfo.health!;
        batteryHealth.value = finalStr.replaceAll('health.', '');
        finalStr = batteryInfo.chargingStatus.toString();
        batteryState.value = finalStr.replaceAll('ChargingStatus.', '');
      }
    });
  }
}
