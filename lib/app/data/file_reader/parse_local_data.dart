import 'dart:io';

import 'package:emulator/app/data/file_reader/local_data.dart';
import 'package:flutter/material.dart';
import 'package:ini/ini.dart';
import 'package:path_provider/path_provider.dart';

class ParseLocalData implements LocalData {
  String configFilePath = '';
  List<Widget> comboBoxes = [];
  bool deviceFounded = false;

  @override
  Future<List<String>> directorySurvey() async {
    /*
    device = [deviceName1,deviceName2 .....]
    */
    Directory applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();

    List<String> device = [];
    Directory directory = Directory('C:/Users/STOCKLAND/Documents/devices');

    await for (var entity
        in directory.list(recursive: false, followLinks: false)) {
      String str = entity.path;

      device.add(str.replaceAll('C:/Users/STOCKLAND/Documents/devices\\', ''));

      // if (await iniChecker(entity)) {
      //   deviceDirectory['iniFilePath'] = "${entity.path}/data/cfg/config.ini";
      // }
    }

    return device;
  }

  Future<bool> iniChecker(Directory directory) async {
    // var configFilePath = "${directory.path}/data/cfg/config.ini";
    File configFile = File(directory.path);
    return await configFile.exists();
  }

  Future<void> iniReader(String path) {
    // TODO: implement iniReader
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>?> iniFileReader(String deviceName) async {
    Directory directory = Directory(
        'C:/Users/STOCKLAND/Documents/devices/$deviceName/data/cfg/config.ini');

    if (await iniChecker(directory)) {
      Map<String, String> iniFileContent = {};
      File configFile = File(directory.path);
      print('dirrrrectory ${directory.path}');
      await configFile
          .readAsLines()
          .then((lines) => Config.fromStrings(lines))
          .then((Config config) {
        iniFileContent['host'] = config.get('server', 'host')!;

        iniFileContent['username'] = config.get('client', 'username')!;
        iniFileContent['password'] = config.get('client', 'password')!;

        iniFileContent['compass'] = config.get('sensor', 'compass')!;
        iniFileContent['accelerometer'] =
            config.get('sensor', 'accelerometer')!;

        iniFileContent['infrared'] = config.get('light', 'infrared')!;
        iniFileContent['led'] = config.get('light', 'led')!;

        iniFileContent['available'] =
            config.get('motiondetection', 'available')!;

        // cfgFile['motoriz'] = config.get('motoriz', 'available')!;
      });
      print(iniFileContent.toString());
      return iniFileContent;
    } else {
      return null;
    }
  }
}
