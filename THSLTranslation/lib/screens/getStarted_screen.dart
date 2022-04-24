// ignore_for_file: file_names, use_key_in_widget_constructors, unused_local_variable, avoid_print, prefer_const_constructors
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:thsltranslation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({
    Key? key,
    required this.camera,
    required this.pref,
  }) : super(key: key);

  final CameraDescription camera;
  final SharedPreferences pref;

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
          SizedBox(height: 8),
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
          SizedBox(height: 40),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 40),
                        titlePadding: EdgeInsets.fromLTRB(16, 40, 16, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        title: Center(
                          child: Text('การบันทึกประวัติการแปล',
                              style: TextStyle(
                                fontFamily: 'Anakotmai',
                                color: Color(0xff2b2b2b),
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                'หากคุณยินยอมให้บันทึกประวัติการแปลของคุณ รูปภาพของคุณจะถูกเก็บในคลังข้อมูลของเรา หากคุณไม่ยินยอมให้บันทึกประวัติการแปล คุณยังสามารถใช้งานแอปพลิเคชันได้ตามปกติ แต่จะไม่สามารถดูประวัติการแปลใด ๆ ได้',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Anakotmai',
                                  color: Color(0xff2b2b2b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(
                              height: 36,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  camera: widget.camera,
                                                  consent: false,
                                                  pref: widget.pref,
                                                )));
                                  },
                                  child: Container(
                                    width: 115,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF0F0EF),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 17),
                                    child: Center(
                                      child: Text('ไม่ยินยอม',
                                          style: TextStyle(
                                            fontFamily: 'Anakotmai',
                                            color: Color(0xff2b2b2b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  camera: widget.camera,
                                                  consent: true,
                                                  pref: widget.pref,
                                                )));
                                  },
                                  child: Container(
                                    width: 115,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(0xff1821AE),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 17),
                                    child: Center(
                                      child: Text('ยินยอม',
                                          style: TextStyle(
                                            fontFamily: 'Anakotmai',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ));
                  });
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
