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

/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'THSL APP',
        theme: ThemeData(fontFamily: 'Anakotmai'
            //primaryColor: const Color(0x)
            ),
        //home: const MyHomePage(title: 'THSL Translation'),
        home: GetStarted());
  }
}*/
