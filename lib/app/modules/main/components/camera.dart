import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../controllers/customcamera_controller.dart';
import 'custom_led.dart';

/// CameraApp is the Main Application.
class CameraApp extends GetView<CustomcameraController> {
  // Function zoomRequest;
  CameraApp(
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

//   State<CameraApp> createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   late CameraController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(cameras[0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

  // void cameraZoom(double zoom) {

  //   controller.cameraController.setZoomLevel(zoom);

  //   print('cam: ${zoom}');
  // }

  @override
  Widget build(BuildContext context) {
    if (controller.cameraControllerObs.value == null) {
      return Container();
    }

    return
        // MaterialApp(
        //   home:
        // CameraPreview(controller);
        Obx(() => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 3),
                shape: BoxShape.rectangle,
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CameraPreview(controller.cameraControllerObs.value!),
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
            ));
    // );
  }
}
