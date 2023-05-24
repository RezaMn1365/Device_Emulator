import 'dart:convert';
import 'dart:io';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

List<FileInfo> fileInfoList = [];

class CustomFileController extends GetxController {
  Future<void> searchDirectory() async {
    Directory? applicationDocumentsDirectory =
        await getExternalStorageDirectory();
    // prepareMetaData(applicationDocumentsDirectory.path + 'media/video');

    List<String> paths = [
      '/data/media/video',
      '/data/media/audio',
      '/data/media/picture',
      '/data/sensor/acceleration',
      '/data/sensor/compass',
      '/data/sensor/gyroscope',
      '/data/sensor/battery',
      '/data/sensor/location'
    ];

    paths.forEach((element) async {
      Directory directory =
          Directory(applicationDocumentsDirectory!.path + element);
      if (await directory.exists() == false) {
        await Directory(applicationDocumentsDirectory.path + element)
            .create(recursive: true);
      } else {}
    });
  }

  Future<void> printResult() async {
    //only for test
    var test = await getExternalStorageDirectory();
    await for (var entity in test!.list(recursive: true, followLinks: false)) {
      print(entity);
    }
  }

  Future<void> prepareMetaData(String filePath) async {
    FileInfo fileinfo = FileInfo();
    File rawFile = File(filePath);

    fileinfo.name = p.basename(rawFile.path).split('.').first;
    fileinfo.relativePath = rawFile.path;
    var checkFileType = await FileSystemEntity.type(rawFile.path);
    var result = checkFileType.toString().trim();
    // print(result);

    if (result == 'file') {
      fileinfo.isDirectory = false;
      fileinfo.extention = p.extension(rawFile.path);
      fileinfo.size = await rawFile.length();
      var modified = await rawFile.lastModified();
      fileinfo.modifiedAt = modified.toString();
    } else if (result == 'directory') {
      fileinfo.isDirectory = true;
      fileinfo.extention = '';
      fileinfo.size = 0;
      fileinfo.modifiedAt = '';
    } else {}

    fileInfoList.add(fileinfo);
  }

  Future<void> getFileList() async {
    searchDirectory();
    fileInfoList.clear();
    Directory? baseDir = await getExternalStorageDirectory();

    await for (var entity
        in baseDir!.list(recursive: true, followLinks: false)) {
      // print('type: ${(await FileSystemEntity.type(entity.path)).toString()}');
      // print('name: ${p.basename(entity.path).split('.').first}');
      // print('ext: ${p.extension(entity.path)}');
      prepareMetaData(entity.path);
    }
    Get.defaultDialog(
        content: Text(
      fileInfoList.toString(),
    ));
    print(fileInfoList);
  }

  Future<void> writeToFile(String filePath, dynamic data) async {
    print('start writing');
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    Directory? systemPath = await getExternalStorageDirectory();
    var path = systemPath!.path + filePath;
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // print(systemPath);

    File dataFile = File(path + '_$timestamp.dat');
    // Battery battery = Battery(charge: 55, health: 'ok');
    // Battery battery1 = Battery(charge: 100, health: 'ok');

    // Battery().writeToBuffer();
    // var result = base64Encode(battery.writeToBuffer()) + '\n';
    // var result1 = base64Encode(battery1.writeToBuffer()) + '\n';
    // var result2 = base64Encode(battery1.writeToBuffer()) + '\n';
    // var result3 = base64Encode(battery1.writeToBuffer()) + '\n';
    // var result4 = base64Encode(battery1.writeToBuffer()) + '\n';
    // await dataFile.writeAsString(result);
    var fileSink =
        dataFile.openWrite(mode: FileMode.writeOnly, encoding: ascii);
    fileSink.add(ascii.encode(data));
    // fileSink.add(ascii.encode(result1));
    // fileSink.add(ascii.encode(result2));
    // fileSink.add(ascii.encode(result3));
    // fileSink.add(ascii.encode(result4));

    await fileSink.close();
    print(dataFile);

    // var xxx = DateTime.now().microsecondsSinceEpoch;

    // dataFile.writeAsBytes(bytes);
  }
}
