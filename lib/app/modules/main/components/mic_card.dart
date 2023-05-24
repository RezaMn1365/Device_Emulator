import 'package:emulator/app/modules/main/components/custom_led.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Microphone extends StatelessWidget {
  Microphone(
      {required this.buttomEnable,
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
      constraints: BoxConstraints(
          maxWidth: Get.width * 0.33, maxHeight: Get.height * 0.25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 3),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: [
          Container(
            // width: Get.width / 4,
            // height: Get.height / 6,
            color: Colors.transparent,
            child: const Center(child: Icon(Icons.mic)),
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
