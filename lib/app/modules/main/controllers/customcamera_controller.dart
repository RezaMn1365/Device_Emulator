import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../main.dart';

class CustomcameraController extends GetxController {
  RxDouble maxZoomLevel = 2.0.obs;
  CameraController cameraController =
      CameraController(cameras[0], ResolutionPreset.high);

  RxBool camButtonEnable = true.obs;

  RxBool buttomEnable = true.obs;
  RxBool locked = false.obs;
  RxBool onOff = false.obs;
  RxBool blinking = false.obs;
  RxString buttomText = 'Pause'.obs;

  final cameraControllerObs = Rx<CameraController?>(null);

  Future<bool> videoRecordingRequest(
      {int? width,
      int? height,
      int? zoom,
      required Duration duration,
      int? bitRate}) async {
    // Future<Directory?>? applicationDocumentsDirectory;
    locked.value = true;
    blinking.value = true;
    onOff.value = true;
    buttomEnable.value = false;

    // Directory applicationDocumentsDirectory =
    //     await getApplicationDocumentsDirectory();
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    Directory? applicationDocumentsDirectory =
        await getExternalStorageDirectory();
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // XFile videoFile = XFile(
    //     applicationDocumentsDirectory!.path + '/data/media/video',
    //     name: 'video_$timestamp.mp4');

    if (cameraControllerObs.value != null &&
        !cameraControllerObs.value!.value.isRecordingVideo) {
      // cameraControllerObs.value = CameraController(cameras[0], resulation,
      //     imageFormatGroup: imageFormatGroup);
      await cameraControllerObs.value!.prepareForVideoRecording();
      await cameraControllerObs.value!.startVideoRecording();

      Timer(duration, () async {
        // XFile videoFile = XFile(applicationDocumentsDirectory.toString());
        try {
          var file = await cameraControllerObs.value!.stopVideoRecording();
          // await GallerySaver.saveVideo(videoFile.path, toDcim: false);
          // videoFile = temp;
          await file.saveTo(applicationDocumentsDirectory!.path +
              '/data/media/video/video_$timestamp.mp4');

          locked.value = false;
          blinking.value = false;
          onOff.value = false;
          buttomEnable.value = true;

          print('video Stopped');
        } catch (e) {
          print('video Stop failed....$e');
        }
      });

      return true;
    }
    locked.value = false;
    blinking.value = false;
    onOff.value = false;
    buttomEnable.value = true;

    return false;
  }

  Future<bool> photoTakingRequest({
    int? width,
    int? height,
    int? zoom,
  }) async {
    // Future<Directory?>? applicationDocumentsDirectory;
    locked.value = true;
    blinking.value = true;
    onOff.value = true;
    buttomEnable.value = false;

    // Directory applicationDocumentsDirectory =
    //     await getApplicationDocumentsDirectory();
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    Directory? applicationDocumentsDirectory =
        await getExternalStorageDirectory();
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // XFile videoFile = XFile(
    //     applicationDocumentsDirectory!.path + '/data/media/video',
    //     name: 'video_$timestamp.mp4');

    if (cameraControllerObs.value != null &&
        !cameraControllerObs.value!.value.isRecordingVideo) {
      // cameraControllerObs.value = CameraController(cameras[0], resulation,
      //     imageFormatGroup: imageFormatGroup);

      // XFile videoFile = XFile(applicationDocumentsDirectory.toString());
      try {
        var file = await cameraControllerObs.value!.takePicture();
        // await GallerySaver.saveVideo(videoFile.path, toDcim: false);
        // videoFile = temp;
        await file.saveTo(applicationDocumentsDirectory!.path +
            '/data/media/picture/picture_$timestamp.jpg');

        locked.value = false;
        blinking.value = false;
        onOff.value = false;
        buttomEnable.value = true;

        print('photo took');
      } catch (e) {
        print('photo took failed....$e');
      }

      return true;
    }
    locked.value = false;
    blinking.value = false;
    onOff.value = false;
    buttomEnable.value = true;

    return false;
  }

  Future<void> onPressed() async {
    onOff.toggle();
    // blinking.toggle();
    if (onOff.value) {
      // await videoRecordingRequest(duration: const Duration(seconds: 10));
      await photoTakingRequest();
      buttomText.value = 'Play';
    } else {
      buttomText.value = 'Pause';
    }
  }

  void init() {
    // getPermissions();
    availableCameras().then((value) {
      cameras = value;
      cameraController = CameraController(cameras[0], ResolutionPreset.medium,
          imageFormatGroup: ImageFormatGroup.yuv420);
      cameraController.initialize().then((_) async {
        cameraControllerObs.value = cameraController;
        maxZoomLevel.value = await cameraController.getMaxZoomLevel();
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      });
    });
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // @override
  // void onInit() {
  //   camController = CameraController(cameras[0], ResolutionPreset.max);
  //   camController.initialize().then((_) {
  //     // if (!mounted) {
  //     //   return;
  //     // }
  //   }).catchError((Object e) {
  //     if (e is CameraException) {
  //       switch (e.code) {
  //         case 'CameraAccessDenied':
  //           // Handle access errors here.
  //           break;
  //         default:
  //           // Handle other errors here.
  //           break;
  //       }
  //     }
  //   });
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
