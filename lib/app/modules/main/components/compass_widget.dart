import 'package:emulator/app/modules/main/components/custom_led.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Compass extends StatelessWidget {
  double positionValue;
  Compass(
      {required this.positionValue,
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
            color: Colors.transparent,
            child: SfRadialGauge(
              title: GaugeTitle(text: 'Compass'),
              axes: <RadialAxis>[
                RadialAxis(
                  startAngle: 270,
                  endAngle: 270,
                  radiusFactor: 0.9,
                  minimum: 0,
                  maximum: 80,
                  axisLineStyle: AxisLineStyle(
                      thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1),
                  interval: 10,
                  canRotateLabels: true,
                  axisLabelStyle: GaugeTextStyle(fontSize: 12),
                  minorTicksPerInterval: 0,
                  majorTickStyle: MajorTickStyle(
                      thickness: 1.5,
                      lengthUnit: GaugeSizeUnit.factor,
                      length: 0.07),
                  showLabels: true,
                  onLabelCreated: labelCreated,
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        enableDragging: true,
                        value: positionValue / 4.5,
                        lengthUnit: GaugeSizeUnit.factor,
                        needleLength: 0.55,
                        needleEndWidth: 18,
                        gradient: const LinearGradient(colors: <Color>[
                          Color(0xFFFF6B78),
                          Color(0xFFFF6B78),
                          Color(0xFFE20A22),
                          Color(0xFFE20A22)
                        ], stops: <double>[
                          0,
                          0.5,
                          0.5,
                          1
                        ]),
                        needleColor: const Color(0xFFF67280),
                        knobStyle: KnobStyle(
                            knobRadius: 0.1,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: Colors.white)),
                    NeedlePointer(
                        gradient: const LinearGradient(colors: <Color>[
                          Color(0xFFE3DFDF),
                          Color(0xFFE3DFDF),
                          Color(0xFF7A7A7A),
                          Color(0xFF7A7A7A)
                        ], stops: <double>[
                          0,
                          0.5,
                          0.5,
                          1
                        ]),
                        value: positionValue < 180
                            ? (positionValue / 4.5) + 40
                            : (positionValue / 4.5) - 40,
                        needleLength: 0.55,
                        lengthUnit: GaugeSizeUnit.factor,
                        needleColor: const Color(0xFFFCACACA),
                        needleEndWidth: 18,
                        knobStyle: KnobStyle(
                            knobRadius: 0.1,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: Colors.white))
                  ],
                )
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

  void labelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '80' || args.text == '0') {
      args.text = 'N';
    } else if (args.text == '10') {
      args.text = 'NE';
    } else if (args.text == '20') {
      args.text = 'E';
    } else if (args.text == '30') {
      args.text = 'SE';
    } else if (args.text == '40') {
      args.text = 'S';
    } else if (args.text == '50') {
      args.text = 'SW';
    } else if (args.text == '60') {
      args.text = 'W';
    } else if (args.text == '70') {
      args.text = 'NW';
    }
  }
}
