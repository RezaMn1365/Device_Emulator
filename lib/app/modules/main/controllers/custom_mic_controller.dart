import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class CustomMicController extends GetxController {
  Stream? stream;
  late StreamSubscription listener;
  static const AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

  RxBool buttomEnable = true.obs;
  RxBool locked = false.obs;
  RxBool onOff = false.obs;
  RxBool blinking = false.obs;
  RxString buttomText = 'Start'.obs;

  void onPressed() async {
    onOff.toggle();
    blinking.toggle();
    // await _startListening();
    if (onOff.value) {
      buttomText.value = 'Recording';
      locked.value = true;
      blinking.value = true;
      onOff.value = true;
      buttomEnable.value = false;
      await audioRecordingRequest(Duration(seconds: 15));
    } else {
      buttomText.value = 'Start';
      locked.value = false;
      blinking.value = false;
      onOff.value = false;
      buttomEnable.value = true;
    }
  }

  Future<void> audioRecordingRequest(Duration duration) async {
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    await Permission.microphone.request();

    Directory? applicationDocumentsDirectory =
        await getExternalStorageDirectory();

    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var path = applicationDocumentsDirectory!.path +
        '/data/media/audio/audio_$timestamp.m4a';

    final record = Record();

// Check and request permission
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: path,
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }

// Get the state of the recorder
// bool isRecording = await record.isRecording();

    Timer(duration, (() async {
      // Stop recording
      await record.stop();
      onPressed();
    }));
  }

  Future<void> _startListening() async {
    if (onOff.value) {
      print("START LISTENING");

      Random rng = new Random();

      // if (onOff.value) return false;
      // if this is the first time invoking the microphone()
      // method to get the stream, we don't yet have access
      // to the sampleRate and bitDepth properties
      print("wait for stream");

      // Default option. Set to false to disable request permission dialogue
      MicStream.shouldRequestPermission(true);

      stream = await MicStream.microphone(
          audioSource: AudioSource.DEFAULT,
          sampleRate: 1000 * (rng.nextInt(50) + 30),
          channelConfig: ChannelConfig.CHANNEL_IN_MONO,
          audioFormat: AUDIO_FORMAT);
      // after invoking the method for the first time, though, these will be available;
      // It is not necessary to setup a listener first, the stream only needs to be returned first
      print(
          "Start Listening to the microphone, sample rate is ${await MicStream.sampleRate}, bit depth is ${await MicStream.bitDepth}, bufferSize: ${await MicStream.bufferSize}");

      listener = stream!.listen((event) {
        print('mic: $event');
      });
      // return true;
    } else {
      listener.cancel();
    }
  }
}
