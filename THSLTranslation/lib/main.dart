import 'package:flutter/material.dart';
import 'package:THSLTranslation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THSL APP',
      theme: ThemeData(
          primaryColor: Color(0xFF3EBACE),
          scaffoldBackgroundColor: Color(0xFFF3F5F7)),
      home: const MyHomePage(title: 'THSL Translationnn'),
    );
  }
}
