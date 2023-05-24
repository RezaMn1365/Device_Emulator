import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'custom_led.dart';

class AccelerometerGauge extends StatelessWidget {
  AccelerometerGauge(
      {required this.pointertValue,
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
  double pointertValue;

  @override
  Widget build(BuildContext context) {
    bool isCardView = true;
    bool isWebFullView = false;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 3),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: Get.width * 0.33, maxHeight: Get.height * 0.25),
            child: SfRadialGauge(
              title: const GaugeTitle(text: 'Acceleration'),
              animationDuration: 1000,
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                    radiusFactor: isWebFullView ? 0.85 : 0.98,
                    startAngle: 180, // 180,
                    endAngle: 360, //360,
                    minimum: 0, // -180,
                    maximum: 50, // 180,
                    showAxisLine: false,
                    showLastLabel: true,
                    majorTickStyle: const MajorTickStyle(
                        length: 0.15,
                        lengthUnit: GaugeSizeUnit.factor,
                        thickness: 2),
                    labelOffset: 8,
                    axisLabelStyle: const GaugeTextStyle(
                        fontFamily: 'Times',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic),
                    minorTicksPerInterval: 5,
                    interval: 10,
                    pointers: <GaugePointer>[
                      NeedlePointer(
                          value: pointertValue,
                          needleStartWidth: 0.5,
                          needleEndWidth: 6,
                          needleColor: Color(0xFFF67280),
                          needleLength: 0.9,
                          enableAnimation: true,
                          animationType: AnimationType.bounceOut,
                          animationDuration: 2500,
                          knobStyle: const KnobStyle(
                              knobRadius: 8,
                              sizeUnit: GaugeSizeUnit.logicalPixel,
                              color: Color(0xFFF67280)))
                    ],
                    minorTickStyle: const MinorTickStyle(
                        length: 0.08,
                        thickness: 1,
                        lengthUnit: GaugeSizeUnit.factor,
                        color: Color(0xFFC4C4C4)),
                    axisLineStyle: const AxisLineStyle(
                        color: Color(0xFFDADADA),
                        thicknessUnit: GaugeSizeUnit.factor,
                        thickness: 0.1)),
              ],
            ),
          ),
          LED(
              buttomEnable: buttomEnable,
              locked: locked,
              onPressed: onPressed,
              onOff: onOff,
              blinking: blinking,
              buttomText: buttomText,
              userColor: userColor)
        ],
      ),
    );
  }
}
