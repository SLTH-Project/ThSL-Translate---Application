import 'package:flutter/material.dart';
import 'package:thsltranslation/screens/getStarted_screen.dart';
import 'dart:async';

import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MaterialApp(
      title: 'THSL APP',
      theme: ThemeData(fontFamily: 'Anakotmai'),
      home: GetStarted(camera: firstCamera)));
}
