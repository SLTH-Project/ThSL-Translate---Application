import 'package:flutter/material.dart';
import 'package:thsltranslation/screens/getStarted_screen.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MaterialApp(
      title: 'THSL APP',
      theme: ThemeData(fontFamily: 'Anakotmai'),
      home: GetStarted(camera: firstCamera)));
}
