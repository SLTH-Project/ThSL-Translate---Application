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

    Route _createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, firstAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    final buttonStarted = InkWell(
      onTap: () {
        Navigator.of(context).push(_createRoute());
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
            //fontFamily: 'Opun',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.white),
      width: screenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SizedBox(height: 50),
          Text(
            'THSL Translation',
            textAlign: TextAlign.center,
            style: TextStyle(
              //fontFamily: 'Opun',
              color: Colors.indigo,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          //SizedBox(height: 50),
          Image(
            image: AssetImage('assets/images/img.png'),
            height: 200,
          ),
          buttonStarted
        ],
      ),
    ));
  }
}
