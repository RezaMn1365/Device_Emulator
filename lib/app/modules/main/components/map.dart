import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/custom_map_controller.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import 'custom_led.dart';

class MapWidget extends GetView<CustomMapController> {
  MapWidget(
      {required this.center,
      required this.buttomEnable,
      required this.locked,
      required this.onPressed,
      required this.onOff,
      required this.blinking,
      required this.buttomText,
      required this.userColor,
      super.key});
  final VoidCallback onPressed;
  bool buttomEnable;
  bool locked;
  bool onOff;
  bool blinking;
  Color userColor;
  String buttomText;
  LatLng center = LatLng(35.70, 51.39);
  LatLng latlng = LatLng(35.70, 51.39);
  // LatLng selectedPoint = LatLng(45, -122);

  double lat = 35.70;
  double lng = 51.39;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FlutterMap(
                mapController: controller.mapControllerObs.value,
                options: MapOptions(
                  // onTap: (tapPosition, point) {
                  //   // selectedPoint = point;
                  //   // lat = point.latitude;
                  //   // lng = point.longitude;
                  //   // print('${point.latitude}, ${point.longitude}');
                  // },
                  center: center,
                  zoom: 13,
                ),
                children: [
                  // locationMarkerLayerWidget(),
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          controller.lat.value,
                          controller.lng.value,
                        ),
                        builder: (context) {
                          return const Icon(
                            Icons.circle_rounded,
                            size: 25,
                            color: Colors.blue,
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: LED(
              buttomEnable: buttomEnable,
              locked: locked,
              onPressed: onPressed,
              onOff: onOff,
              blinking: blinking,
              buttomText: buttomText,
              userColor: userColor),
        ),
      ],
    );
  }

  Widget locationMarkerLayerWidget() {
    return CurrentLocationLayer(
        // followOnLocationUpdate: FollowOnLocationUpdate.once,
        // turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
        // style: const LocationMarkerStyle(
        //   marker: DefaultLocationMarker(
        //     child: Icon(
        //       Icons.circle_notifications_rounded,
        //       color: Colors.black,
        //     ),
        //   ),
        //   markerSize: Size(40, 40),
        //   markerDirection: MarkerDirection.heading,
        // ),
        );
  }
}
