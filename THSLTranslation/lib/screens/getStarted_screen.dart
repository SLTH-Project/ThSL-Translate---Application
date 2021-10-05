// ignore_for_file: file_names

import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    final buttonStarted = new InkWell(
      onTap: () {
        print('go to home page');
      },
      child: new Container(
        margin: EdgeInsets.only(top: 30.0),
        width: 300,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          'Get Started',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Opun',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
