import 'dart:async';
import 'dart:convert';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'custom_file_controller.dart';

class CustomGyroController extends GetxController {
  var fileController = Get.find<CustomFileController>();

  RxList<double> gyroscopeValues = <double>[0, 0, 0].obs;
  late StreamSubscription<GyroscopeEvent> gyroStream;
  RxBool isRunning = false.obs;
  RxDouble x = 0.0.obs;
  RxDouble y = 0.0.obs;
  RxDouble z = 0.0.obs;

  RxBool buttomEnable = true.obs;
  RxBool locked = false.obs;
  RxBool onOff = false.obs;
  RxBool blinking = false.obs;
  RxString buttomText = 'Press'.obs;

  void onPressed() async {
    await makeReportFile();
  }

  final count = 0.obs;
  @override
  void onInit() {
    // start();
    super.onInit();
  }

  Future<void> startStream() async {
    if (!isRunning.value) {
      await start();
    }
  }

  Future<void> stoptStream() async {
    if (isRunning.value) {
      await stop();
    }
  }

  Future<void> makeReportFile() async {
    var rawData = await getSample();
    var data = base64Encode(rawData.writeToBuffer()) + '\n';
    fileController.writeToFile('/data/sensor/gyroscope/gyroscope', data);
  }

  Future<ReportMessage> getSample() async {
    // only get 1 sample >>>> if running returns last sample else only get one sample with stream.first method
    if (isRunning.value) {
      return ReportMessage(
          gyroscope: Gyroscope(
              allAxis: gyroscopeValues,
              xGyroscpoe: x.value,
              yGyroscpoe: y.value,
              zGyroscpoe: z.value));
    } else {
      var result = await gyroscopeEvents.first;
      List<double> allValues = [];
      allValues.addAll([result.x * 100, result.y * 100, result.z * 100]);
      return ReportMessage(
          gyroscope: Gyroscope(
              allAxis: allValues,
              xGyroscpoe: result.x,
              yGyroscpoe: result.y,
              zGyroscpoe: result.z));
    }
  }

  Future<void> start() async {
    buttomEnable.value = false;
    locked.value = true;
    onOff.value = true;
    blinking.value = true;
    buttomText.value = 'processing...';
    isRunning.value = true;

    gyroStream = gyroscopeEvents.listen((GyroscopeEvent event) {
      x.value = event.x;
      y.value = event.y;
      z.value = event.z;
      gyroscopeValues.clear();
      gyroscopeValues.addAll([event.x * 100, event.y * 100, event.z * 100]);
      ReportMessage(
          gyroscope: Gyroscope(
              allAxis: gyroscopeValues,
              xGyroscpoe: x.value,
              yGyroscpoe: y.value,
              zGyroscpoe: z.value));

      // print('gyr: $gyroscopeValues');
    });
  }

  Future<void> stop() async {
    buttomEnable.value = false;
    locked.value = false;
    onOff.value = false;
    blinking.value = false;
    buttomText.value = 'Press';
    isRunning.value = false;
    await gyroStream.cancel();
  }
}
