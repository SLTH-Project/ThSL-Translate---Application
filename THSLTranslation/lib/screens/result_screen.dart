// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'dart:io';

import 'package:thsltranslation/screens/home_screen.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {Key? key, required this.image, required this.name, required this.camera})
      : super(key: key);

  final File image;
  //final TensorImage image;
  final String name;
  final CameraDescription camera;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    String vocab = '';

    if (widget.name == 'add') {
      vocab = 'บวก';
    } else if (widget.name == 'animal') {
      vocab = 'สัตว์';
    } else if (widget.name == 'bowl') {
      vocab = 'ถ้วย';
    } else if (widget.name == 'buffalo') {
      vocab = 'กระบือ';
    } else if (widget.name == 'care') {
      vocab = 'ห่วงใย';
    } else if (widget.name == 'cat') {
      vocab = 'แมว';
    } else if (widget.name == 'chest') {
      vocab = 'อก';
    } else if (widget.name == 'cow') {
      vocab = 'วัว';
    } else if (widget.name == 'deer') {
      vocab = 'กวาง';
    } else if (widget.name == 'divide') {
      vocab = 'หาร';
    } else if (widget.name == 'double') {
      vocab = 'ทวีคูณ';
    } else if (widget.name == 'eight') {
      vocab = 'เลข 8';
    } else if (widget.name == 'elbow') {
      vocab = 'ข้อศอก';
    } else if (widget.name == 'eye') {
      vocab = 'ตา';
    } else if (widget.name == 'finger') {
      vocab = 'นิ้ว';
    } else if (widget.name == 'five') {
      vocab = 'เลข 5';
    } else if (widget.name == 'four') {
      vocab = 'เลข 4';
    } else if (widget.name == 'gun') {
      vocab = 'ปืน';
    } else if (widget.name == 'hair') {
      vocab = 'ผม';
    } else if (widget.name == 'hand') {
      vocab = 'มือ';
    } else if (widget.name == 'he') {
      vocab = 'เขา';
    } else if (widget.name == 'head') {
      vocab = 'ศีรษะ';
    } else if (widget.name == 'love') {
      vocab = 'รัก';
    } else if (widget.name == 'me') {
      vocab = 'ฉัน';
    } else if (widget.name == 'meditate') {
      vocab = 'นั่งสมาธิ';
    } else if (widget.name == 'mushroom') {
      vocab = 'เห็ด';
    } else if (widget.name == 'nine') {
      vocab = 'เลข 9';
    } else if (widget.name == 'noon') {
      vocab = 'เที่ยงวัน';
    } else if (widget.name == 'nose') {
      vocab = 'จมูก';
    } else if (widget.name == 'one') {
      vocab = 'เลข 1';
    } else if (widget.name == 'rat') {
      vocab = 'หนู';
    } else if (widget.name == 'remember') {
      vocab = 'จดจำ';
    } else if (widget.name == 'rhinoceros') {
      vocab = 'แรด';
    } else if (widget.name == 'salty') {
      vocab = 'เค็ม';
    } else if (widget.name == 'serve') {
      vocab = 'บริการ';
    } else if (widget.name == 'seven') {
      vocab = 'เลข 7';
    } else if (widget.name == 'shirt') {
      vocab = 'เสื้อ';
    } else if (widget.name == 'shoulder') {
      vocab = 'ไหล่';
    } else if (widget.name == 'sick') {
      vocab = 'ป่วย';
    } else if (widget.name == 'six') {
      vocab = 'เลข 6';
    } else if (widget.name == 'soldier') {
      vocab = 'ทหาร';
    } else if (widget.name == 'teeth') {
      vocab = 'ฟัน';
    } else if (widget.name == 'three') {
      vocab = 'เลข 3';
    } else if (widget.name == 'tiger') {
      vocab = 'เสือ';
    } else if (widget.name == 'time') {
      vocab = 'เวลา';
    } else if (widget.name == 'tongue') {
      vocab = 'ลิ้น';
    } else if (widget.name == 'two') {
      vocab = 'เลข 2';
    } else if (widget.name == 'wedding') {
      vocab = 'งานแต่งงาน';
    } else if (widget.name == 'win') {
      vocab = 'ชนะ';
    } else if (widget.name == 'zero') {
      vocab = 'เลข 0';
    }

    final reButton = InkWell(
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
            'เริ่มการจับภาพใหม่',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Anakotmai',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));

    return Scaffold(
      backgroundColor: Color(0xF7F7F7FF),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(camera: widget.camera)));
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            )),
        title: Text('THSL Translate',
            style: TextStyle(
              fontFamily: 'Anakotmai',
              color: Color(0xFF2B2B2B),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Image.file(
              widget.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text("ผลการแปลภาษามือไทย",
              style: TextStyle(
                fontFamily: 'Anakotmai',
                color: Color(0xFF2B2B2B),
                fontSize: 20,
                fontWeight: FontWeight.normal,
              )),
          Text(vocab,
              style: TextStyle(
                fontFamily: 'Anakotmai',
                color: Color(0xFF2B2B2B),
                fontSize: 50,
                fontWeight: FontWeight.w700,
              )),
          reButton,
          SizedBox(
            height: 50,
          )
        ],
      )),

      /*Image.file(
          File(widget.imagePath),
          scale: 0.61,
        )*/
      /*AspectRatio(
          aspectRatio: 487 / 451,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.topCenter,
                    image: AssetImage(widget.imagePath))),
          ),
        )*/
    );
  }
}
