import 'package:emulator/app/modules/main/components/accelerometer_gauge.dart';
import 'package:emulator/app/modules/main/components/battery_gauge.dart';
import 'package:emulator/app/modules/main/components/camera.dart';
import 'package:emulator/app/modules/main/components/compass_widget.dart';
import 'package:emulator/app/modules/main/components/custom_led.dart';
import 'package:emulator/app/modules/main/components/map.dart';
import 'package:emulator/app/modules/main/components/slider.dart';
import 'package:emulator/app/modules/main/controllers/customcamera_controller.dart';
import 'package:emulator/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../components/gyroscope_gauge.dart';
import '../components/mic_card.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  MainView({Key? key}) : super(key: key);

  sliderValueUpdate(double sliderValueUpdate) {
    controller.sliderValue.value = sliderValueUpdate;
  }

  zoomSliderValueUpdate(double zoomValueUpdate) {
    controller.zoomsliderValue.value = zoomValueUpdate;
    Get.find<CustomcameraController>()
        .cameraControllerObs
        .value!
        .setZoomLevel(zoomValueUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Main'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (() => Get.offAllNamed(Routes.HOME)),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CameraApp(
                                    buttomEnable: controller
                                        .camController.buttomEnable.value,
                                    locked:
                                        controller.camController.locked.value,
                                    onPressed:
                                        controller.camController.onPressed,
                                    onOff: controller.camController.onOff.value,
                                    blinking:
                                        controller.camController.blinking.value,
                                    buttomText: controller
                                        .camController.buttomText.value,
                                    userColor: Colors.amber,
                                  )

                                  //  const Text('Camera Preview!',
                                  //     style: TextStyle(color: Colors.white)),

                                  ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  SliderWidget(
                                    isVertical: true,
                                    maxZoomLevel:
                                        Get.find<CustomcameraController>()
                                            .maxZoomLevel
                                            .value,
                                    positionValue:
                                        controller.zoomsliderValue.value,
                                    onChanged: ((value) =>
                                        zoomSliderValueUpdate(value)),
                                  ),
                                  Text('Zoom level')
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: AccelerometerGauge(
                                    pointertValue: controller
                                        .accController.acceleration.value,
                                    buttomEnable: controller
                                        .accController.buttomEnable.value,
                                    locked:
                                        controller.accController.locked.value,
                                    onPressed:
                                        controller.accController.onPressed,
                                    onOff: controller.accController.onOff.value,
                                    blinking:
                                        controller.accController.blinking.value,
                                    buttomText: controller
                                        .accController.buttomText.value,
                                    userColor: Colors.brown)),
                            Expanded(
                                flex: 3,
                                child: Compass(
                                    positionValue: controller
                                        .compassController.direction.value,
                                    buttomEnable: controller
                                        .compassController.buttomEnable.value,
                                    locked: controller
                                        .compassController.locked.value,
                                    onPressed:
                                        controller.compassController.onPressed,
                                    onOff: controller
                                        .compassController.onOff.value,
                                    blinking: controller
                                        .compassController.blinking.value,
                                    buttomText: controller
                                        .compassController.buttomText.value,
                                    userColor: Colors.purple)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: GyroscopeGauge(
                                    x: controller
                                        .gyroController.gyroscopeValues[0],
                                    y: controller
                                        .gyroController.gyroscopeValues[1],
                                    z: controller
                                        .gyroController.gyroscopeValues[2],
                                    buttomEnable: controller
                                        .gyroController.buttomEnable.value,
                                    locked:
                                        controller.gyroController.locked.value,
                                    onPressed:
                                        controller.gyroController.onPressed,
                                    onOff:
                                        controller.gyroController.onOff.value,
                                    blinking: controller
                                        .gyroController.blinking.value,
                                    buttomText: controller
                                        .gyroController.buttomText.value,
                                    userColor: Colors.pink)),
                            Expanded(
                              flex: 3,
                              child: BatteryGauge(
                                  batteryPercentage: controller
                                      .battController.batteryPercentage.value,
                                  batteryState: controller
                                      .battController.batteryState.value,
                                  batteryHealth: controller
                                      .battController.batteryHealth.value,
                                  buttomEnable: controller
                                      .battController.buttomEnable.value,
                                  locked:
                                      controller.battController.locked.value,
                                  onPressed:
                                      controller.battController.onPressed,
                                  onOff: controller.battController.onOff.value,
                                  blinking:
                                      controller.battController.blinking.value,
                                  buttomText: controller
                                      .battController.buttomText.value,
                                  userColor: Colors.orange),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Microphone(
                                    buttomEnable: controller
                                        .micController.buttomEnable.value,
                                    locked:
                                        controller.micController.locked.value,
                                    onPressed:
                                        controller.micController.onPressed,
                                    onOff: controller.micController.onOff.value,
                                    blinking:
                                        controller.micController.blinking.value,
                                    buttomText: controller
                                        .micController.buttomText.value,
                                    userColor: Colors.redAccent)),
                          ],
                        ),
                        // LED(
                        //     buttomEnable: true,
                        //     locked: false,
                        //     onPressed: () =>
                        //         controller.accController.getSample(),
                        //     onOff: false,
                        //     blinking: false,
                        //     buttomText: 'buttomText',
                        //     userColor: Colors.amber),
                        SizedBox(
                          height: Get.height / 3,
                          width: Get.width / 0.9,
                          child: InteractiveViewer(
                              child: MapWidget(
                                  center: LatLng(
                                      controller.mapController.lat.value,
                                      controller.mapController.lng.value),
                                  buttomEnable: controller
                                      .mapController.buttomEnable.value,
                                  locked: controller.mapController.locked.value,
                                  onPressed: controller.mapController.onPressed,
                                  onOff: controller.mapController.onOff.value,
                                  blinking:
                                      controller.mapController.blinking.value,
                                  buttomText:
                                      controller.mapController.buttomText.value,
                                  userColor: Colors.green)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
