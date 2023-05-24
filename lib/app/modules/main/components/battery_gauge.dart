import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'custom_led.dart';

class BatteryGauge extends StatelessWidget {
  BatteryGauge(
      {required this.batteryPercentage,
      required this.batteryState,
      required this.batteryHealth,
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
  int batteryPercentage;
  String batteryState;
  String batteryHealth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 3),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: [
          Container(
              constraints: BoxConstraints(
                  maxWidth: Get.width * 0.33, maxHeight: Get.height * 0.25),
              child: SfRadialGauge(
                animationDuration: 2000,
                title: GaugeTitle(text: batteryState),
                enableLoadingAnimation: true,
                axes: <RadialAxis>[
                  RadialAxis(
                      showLabels: false,
                      showAxisLine: false,
                      showTicks: false,
                      minimum: 0,
                      maximum: 99,
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0,
                            endValue: 33,
                            color: Color(0xFFFE2A25),
                            // label: 'Low',
                            sizeUnit: GaugeSizeUnit.factor,
                            labelStyle: GaugeTextStyle(
                                fontFamily: 'Times', fontSize: 12),
                            startWidth: 0.45,
                            endWidth: 0.45),
                        GaugeRange(
                          startValue: 33,
                          endValue: 66,
                          color: Color(0xFFFFBA00),
                          label: batteryHealth,
                          labelStyle:
                              GaugeTextStyle(fontFamily: 'Times', fontSize: 8),
                          startWidth: 0.45,
                          endWidth: 0.45,
                          sizeUnit: GaugeSizeUnit.factor,
                        ),
                        GaugeRange(
                          startValue: 66,
                          endValue: 99,
                          color: Color(0xFF00AB47),
                          // label: 'Good',
                          labelStyle:
                              GaugeTextStyle(fontFamily: 'Times', fontSize: 12),
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.45,
                          endWidth: 0.45,
                        ),
                      ],
                      pointers: <GaugePointer>[
                        // NeedlePointer(
                        //   value: 60,
                        // ),
                        MarkerPointer(
                          color: Colors.blueGrey,
                          markerType: MarkerType.invertedTriangle,
                          markerWidth: 6,
                          markerHeight: 6,
                          value: batteryPercentage.toDouble(),
                        ),
                        RangePointer(
                          width: 5,
                          color: Colors.blueGrey,
                          value: batteryPercentage.toDouble(),
                        ),
                      ])
                ],
              )),
          LED(
              buttomEnable: true,
              locked: false,
              onPressed: onPressed,
              onOff: true,
              blinking: true,
              buttomText: buttomText,
              userColor: userColor)
        ],
      ),
    );
  }
}
