import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'custom_led.dart';

class GyroscopeGauge extends StatelessWidget {
  GyroscopeGauge(
      {required this.x,
      required this.y,
      required this.z,
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
  double x;
  double y;
  double z;

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
              title: GaugeTitle(text: 'Gyroscope'),
              axes: <RadialAxis>[
                RadialAxis(
                    showAxisLine: false,
                    radiusFactor: isWebFullView ? 0.43 : 0.5,
                    startAngle: 270,
                    endAngle: 270,
                    maximum: 360,
                    showFirstLabel: false,
                    showLastLabel: true,
                    interval: 45,
                    labelOffset: 0,
                    minorTicksPerInterval: 5,
                    axisLabelStyle: const GaugeTextStyle(fontSize: 8),
                    // onLabelCreated: _handleAxisLabelCreated,
                    minorTickStyle: const MinorTickStyle(
                        lengthUnit: GaugeSizeUnit.factor,
                        length: 0.03,
                        thickness: 1),
                    majorTickStyle: const MajorTickStyle(
                        lengthUnit: GaugeSizeUnit.factor, length: 0.1)),
                RadialAxis(
                    showAxisLine: false,
                    radiusFactor: isWebFullView ? 0.43 : 0.7,
                    startAngle: 270,
                    endAngle: 270,
                    maximum: 360,
                    showFirstLabel: false,
                    showLastLabel: true,
                    interval: 45,
                    labelOffset: 0,
                    minorTicksPerInterval: 5,
                    axisLabelStyle: const GaugeTextStyle(fontSize: 8),
                    // onLabelCreated: _handleAxisLabelCreated,
                    minorTickStyle: const MinorTickStyle(
                        lengthUnit: GaugeSizeUnit.factor,
                        length: 0.03,
                        thickness: 1),
                    majorTickStyle: const MajorTickStyle(
                        lengthUnit: GaugeSizeUnit.factor, length: 0.1)),
                RadialAxis(
                    axisLineStyle: const AxisLineStyle(
                        thicknessUnit: GaugeSizeUnit.factor,
                        thickness: 0.08,
                        color: Color.fromARGB(255, 3, 210, 247)),
                    startAngle: 270,
                    endAngle: 270,
                    maximum: 360,
                    radiusFactor: isWebFullView ? 0.8 : 0.9,
                    showFirstLabel: false,
                    showLastLabel: true,
                    interval: 45,
                    labelOffset: 2,
                    axisLabelStyle:
                        GaugeTextStyle(fontSize: isCardView ? 8 : 12),
                    minorTicksPerInterval: 5,
                    // onLabelCreated: _handleAxisLabelCreated,
                    minorTickStyle: const MinorTickStyle(
                        lengthUnit: GaugeSizeUnit.factor,
                        length: 0.05,
                        thickness: 1),
                    majorTickStyle: const MajorTickStyle(
                        lengthUnit: GaugeSizeUnit.factor, length: 0.1),
                    pointers: <GaugePointer>[
                      NeedlePointer(
                          value: x,
                          needleLength: 0.35,
                          needleColor: Color.fromARGB(255, 5, 204, 64),
                          needleStartWidth: 0,
                          needleEndWidth: isCardView ? 3 : 5,
                          enableAnimation: true,
                          knobStyle: const KnobStyle(knobRadius: 0)),
                      NeedlePointer(
                          value: y,
                          needleLength: 0.55,
                          needleColor: const Color(0xFFF67280),
                          needleStartWidth: 0,
                          needleEndWidth: isCardView ? 3 : 5,
                          enableAnimation: true,
                          knobStyle: const KnobStyle(knobRadius: 0)),
                      NeedlePointer(
                        value: z,
                        needleLength: 0.85,
                        needleColor: Color.fromARGB(255, 6, 48, 235),
                        needleStartWidth: 0,
                        needleEndWidth: isCardView ? 3 : 5,
                        enableAnimation: true,
                        knobStyle: KnobStyle(
                            borderColor: const Color(0xFFF67280),
                            borderWidth: 0.015,
                            color: Colors.white,
                            knobRadius: isCardView ? 0.04 : 0.05),
                      ),
                    ]),
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
