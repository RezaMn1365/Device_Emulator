import 'dart:async';

// import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

import 'custom_bluetooth_controller.dart';

class CustomBeaconController extends GetxController {
  // BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  late StreamSubscription<RangingResult> streamRanging;
  RxString status = 'Start'.obs;
  RxString listen = 'Listen'.obs;

  // final bleController = Get.find<CustomBluetoothController>();

  Future<void> start() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothAdvertise.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();
    // await beaconBroadcast
    //     .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
    //     .setMajorId(1)
    //     .setMinorId(100)
    //     .start();
    await flutterBeacon.startBroadcast(BeaconBroadcast(
      txPower: 20,
      identifier: 'ACCESSTOKEN-PRIVATE-0XFFEEAA',
      proximityUUID:
          '39ED98FF-0000-0000-802F-00008FC19000', //'39ED98FF-2900-441A-802F-9C398FC199D2',
      major: 1,
      minor: 100,
    ));
    status.value = 'Stop';

    ///
    ///ALTBEACON	m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25
    // EDDYSTONE  TLM	x,s:0-1=feaa,m:2-2=20,d:3-3,d:4-5,d:6-7,d:8-11,d:12-15
    // EDDYSTONE  UID	s:0-1=feaa,m:2-2=00,p:3-3:-41,i:4-13,i:14-19
    // EDDYSTONE  URL	s:0-1=feaa,m:2-2=10,p:3-3:-41,i:4-20v
    // IBEACON  	m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24
    ///
  }

  Future<void> stopBroadCasting() async {
    await flutterBeacon.stopBroadcast();
    status.value = 'Start';
  }

  Future<void> beacon() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothAdvertise.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();
    await flutterBeacon.initializeScanning;

    final regions = <Region>[];

// Android platform, it can ranging out of beacon that filter all of Proximity UUID
    regions.add(Region(identifier: 'ACCESSTOKEN-PRIVATE-0XFFEEAA'));
    await flutterBeacon.initializeScanning;

    // to start monitoring beacons
    streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) async {
      // result contains a region, event type and event state
      // Get.defaultDialog(content: Text('data'));
      // print(result);
      // print(result.toJson);
      if (result.beacons.isNotEmpty) {
        Get.defaultDialog(content: Text(result.beacons.toString()));
        await streamRanging.cancel();
        listen.value = 'Listen';
      }
      print(result.beacons.toString());
    });
    listen.value = 'Listening';
  }

  // StreamSubscription<RangingResult>? _streamRanging;
  // final _regionBeacons = <Region, List<Beacon>>{};
  // RxList beacons = <Beacon>[].obs;

  // var bluetoothState = BluetoothState.stateOff.obs;
  // var authorizationStatus = AuthorizationStatus.notDetermined.obs;
  // var locationService = false.obs;

  // updateBluetoothState(BluetoothState state) {
  //   bluetoothState.value = state;
  // }

  // updateAuthorizationStatus(AuthorizationStatus status) {
  //   authorizationStatus.value = status;
  // }

  // updateLocationService(bool flag) {
  //   locationService.value = flag;
  // }

  // startBroadcasting() {}

  // stopBroadcasting() {}

  // startScanning() {}

  // pauseScanning() {}

  // initScanBeacon() async {
  //   await Permission.bluetooth.request();
  //   await Permission.bluetoothAdvertise.request();
  //   await Permission.bluetoothConnect.request();
  //   await Permission.bluetoothScan.request();
  //   await Permission.locationWhenInUse.request();
  //   // if (!authorizationStatusOk) {
  //   //   await flutterBeacon.requestAuthorization;
  //   // }
  //   // if (!locationServiceEnabled) {
  //   //   await flutterBeacon.openLocationSettings;
  //   // }
  //   // if (!bluetoothEnabled) {
  //   //   await flutterBeacon.openBluetoothSettings;
  //   // }

  //   await flutterBeacon.initializeScanning;
  //   // if (!authorizationStatusOk ||
  //   //     !locationServiceEnabled ||
  //   //     !bluetoothEnabled) {
  //   //   print('RETURNED, authorizationStatusOk=${authorizationStatusOk}, '
  //   //       'locationServiceEnabled=${locationServiceEnabled}, '
  //   //       'bluetoothEnabled=${bluetoothEnabled}');
  //   //   return;
  //   // }

  //   final regions = <Region>[
  //     Region(
  //       identifier: 'Cubeacon',
  //       proximityUUID: 'CB10023F-A318-3394-4199-A8730C7C1AEC',
  //     ),
  //     Region(
  //       identifier: 'BeaconType2',
  //       proximityUUID: '6a84c716-0f2a-1ce9-f210-6a63bd873dd9',
  //     ),
  //   ];

  //   _streamRanging =
  //       flutterBeacon.ranging(regions).listen((RangingResult result) {
  //     // if (mounted) {
  //     // setState(() {
  //     print(result);
  //     _regionBeacons[result.region] = result.beacons;
  //     beacons.clear();
  //     _regionBeacons.values.forEach((list) {
  //       list.forEach((element) {
  //         beacons.add(element);
  //         print(beacons);
  //       });
  //     });
  //   });
  // }

  // pauseScanBeacon() async {
  //   _streamRanging?.pause();
  //   if (beacons.isNotEmpty) {
  //     // setState(() {
  //     beacons.clear();
  //     // });
  //   }
  // }

  // @override
  // void onInit() {
  //   print('start stream');
  //   initScanBeacon();

  //   // pauseStream.listen((flag) {
  //   //   if (flag == true) {
  //   //     pauseScanBeacon();
  //   //   }
  //   // });
  //   super.onInit();
  // }
}
