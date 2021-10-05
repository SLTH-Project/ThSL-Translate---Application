// ignore_for_file: file_names

import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(height: 50),
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
          SizedBox(height: 50),
          Image(
            image: AssetImage('assets/images/img.png'),
            height: 200,
          )
        ],
      ),
    );
  }
}
