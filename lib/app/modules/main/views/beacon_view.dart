import 'dart:async';

import 'package:emulator/app/modules/home/views/home_view.dart';
import 'package:emulator/app/modules/main/controllers/custom_beacon_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_bluetooth_controller.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_beacon/flutter_beacon.dart';

import 'package:get/get.dart';

class BeaconView extends GetView<CustomBeaconController> {
  BeaconView({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body:
              //  controller.beacons.isEmpty?
              Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: ElevatedButton(
                    onPressed: controller.status.value == 'Start'
                        ? (() async => await controller.start())
                        : () async => await controller.stopBroadCasting(),
                    child: Text(controller.status.value)),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: (() async => await controller.beacon()),
                    child: Text(controller.listen.value)),
              )
            ],
          ),
          // : ListView(
          //     children: ListTile.divideTiles(
          //       context: context,
          //       tiles: controller.beacons.map(
          //         (beacon) {
          //           return ListTile(
          //             title: Text(
          //               beacon.proximityUUID,
          //               style: const TextStyle(fontSize: 15.0),
          //             ),
          //             subtitle: new Row(
          //               mainAxisSize: MainAxisSize.max,
          //               children: <Widget>[
          //                 Flexible(
          //                   child: Text(
          //                     'Major: ${beacon.major}\nMinor: ${beacon.minor}',
          //                     style: TextStyle(fontSize: 13.0),
          //                   ),
          //                   flex: 1,
          //                   fit: FlexFit.tight,
          //                 ),
          //                 Flexible(
          //                   child: Text(
          //                     'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
          //                     style: TextStyle(fontSize: 13.0),
          //                   ),
          //                   flex: 2,
          //                   fit: FlexFit.tight,
          //                 )
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //     ).toList(),
          //   ),
        ));
  }
}
