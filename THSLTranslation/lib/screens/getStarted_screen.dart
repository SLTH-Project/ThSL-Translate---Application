// ignore_for_file: file_names, use_key_in_widget_constructors, unused_local_variable, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:thsltranslation/screens/home_screen.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color(0xEBEEF5FF)),
      width: screenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SizedBox(height: 50),
          Text(
            'THSL Translate',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Anakotmai',
              color: Colors.indigo,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          //SizedBox(height: 50),
          Image(
            image: AssetImage('assets/images/logo.png'),
            height: 200,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(
                'Get Started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Anakotmai',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
