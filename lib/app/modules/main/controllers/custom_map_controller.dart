import 'dart:async';
import 'dart:convert';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'custom_file_controller.dart';

class CustomMapController extends GetxController {
  var fileController = Get.find<CustomFileController>();

  late StreamSubscription<Position> positionStream;
  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;
  MapController mapController = MapController();
  final mapControllerObs = Rx<MapController?>(null);

  RxBool isRunning = false.obs;

  RxBool buttomEnable = true.obs;
  RxBool locked = false.obs;
  RxBool onOff = false.obs;
  RxBool blinking = false.obs;
  RxString buttomText = 'Press'.obs;

  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  @override
  void onInit() {
    // _determinePosition();
    // requestPermissions();
    super.onInit();
  }

  void onPressed() async {
    // isRunning.value ? await stop() : await start();
    // onOff.toggle();
    // blinking.toggle();
    // isRunning.toggle();
    await makeReportFile();
  }

  Future<void> start() async {
    await Geolocator.requestPermission();
    buttomEnable.value = true;
    locked.value = true;
    onOff.value = true;
    blinking.value = true;
    buttomText.value = 'processing...';
    isRunning.value = true;
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position == null) {
          lat.value = 0.0;
          lng.value = 0.0;
          // mapControllerObs.value = mapController;
        } else {
          lat.value = position.latitude;
          lng.value = position.longitude;
          mapControllerObs.value!.center.latitude = lat.value;
          mapControllerObs.value!.center.longitude = lng.value;
          // mapControllerObs.value = mapController;
          print('got location');
        }
        // print(position == null
        //     ? 'Unknown'
        //     : '${position.latitude.toString()}, ${position.longitude.toString()}');
      },
    );
    // await Geolocator.getCurrentPosition();
    // mapControllerObs.value = mapController;
    mapControllerObs.value = mapController;
  }

  Future<void> stop() async {
    buttomEnable.value = false;
    locked.value = false;
    onOff.value = false;
    blinking.value = false;
    buttomText.value = 'Press';
    isRunning.value = false;
    await positionStream.cancel();
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
    fileController.writeToFile('/data/sensor/location/location', data);
  }

  Future<ReportMessage> getSample() async {
    await Geolocator.requestPermission();
    if (isRunning.value) {
      return ReportMessage(location: Location(lat: lat.value, lng: lng.value));
    } else {
      var result =
          await Geolocator.getPositionStream(locationSettings: locationSettings)
              .first;
      return ReportMessage(
          location: Location(lat: result.latitude, lng: result.longitude));
    }
  }

  // void requestPermissions() async {
  //   var result = await Permission.locationWhenInUse.request();
  //   if (result.isDenied || result.isPermanentlyDenied) {
  //     Get.defaultDialog(
  //         content: const Text('Location services permission is not granted!'));
  //   }

  //   // bool serviceEnabled;
  //   // LocationPermission permission;

  //   // serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   // if (!serviceEnabled) {
  //   //   // return Future.error('Location services are disabled.');
  //   //   Get.defaultDialog(content: const Text('Location services are disabled.'));
  //   //   isRunning.value = false;
  //   // }

  //   // permission = await Geolocator.checkPermission();
  //   // if (permission == LocationPermission.denied) {
  //   //   permission = await Geolocator.requestPermission();
  //   //   if (permission == LocationPermission.denied) {
  //   //     // return Future.error('Location permissions are denied');
  //   //     Get.defaultDialog(
  //   //         content: const Text('Location permissions are denied.'));
  //   //     isRunning.value = false;
  //   //   }
  //   //   isRunning.value = false;
  //   // }

  //   // if (permission == LocationPermission.deniedForever) {
  //   //   // return Future.error(
  //   //   //     'Location permissions are permanently denied, we cannot request permissions.');
  //   //   Get.defaultDialog(
  //   //       content: const Text(
  //   //           'Location permissions are permanently denied, we cannot request permissions.'));
  //   //   isRunning.value = false;
  //   // }
  // }
}
