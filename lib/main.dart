import 'package:camera/camera.dart';
import 'package:emulator/app/core/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';

import 'app/data/storage/storage.dart';
import 'app/routes/app_pages.dart';

late List<CameraDescription> cameras;
void main() async {
  await Storage().init();
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      locale: const Locale('en', ''),
    ),
  );
}
