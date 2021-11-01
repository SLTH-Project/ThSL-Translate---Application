// ignore_for_file: file_names, use_key_in_widget_constructors, unused_local_variable, avoid_print, prefer_const_constructors
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:thsltranslation/screens/home_screen.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

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
          Image(
            image: AssetImage('assets/images/logo.png'),
            height: 150,
          ),
          SizedBox(height: 10),
          Text(
            'THSL Translate',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Anakotmai',
              color: Color(0xff2b2b2b),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 50),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(camera: widget.camera)));
            },
            child: Container(
              padding: const EdgeInsets.only(top: 11),
              width: 230,
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xff1821ae),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Text(
                'เริ่มต้นใช้งาน',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Anakotmai',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
