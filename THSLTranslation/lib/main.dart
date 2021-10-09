import 'package:flutter/material.dart';
import 'package:thsltranslation/screens/getStarted_screen.dart';
//import 'package:thsltranslation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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
}
