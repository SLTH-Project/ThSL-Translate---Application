// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:thsltranslation/screens/home_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:thsltranslation/models/classifier.dart';
import 'package:thsltranslation/models/classifier_float.dart';
import 'package:logger/logger.dart';

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
  bool haveHistory = false;

  //----------Classify---------------------
  Classifier _classifier = ClassifierFloat();

  var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  img.Image? fox;

  Category? category;
  //----------------------------------------

  String meaningThai = '';

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierFloat();
    /* controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = controller.initialize();*/
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
//      _imageWidget = Image.file(_image!);
      print("get image");
      _predict(_image!);
    });
  }

  _predict(File image) async {
    print("in predict");
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);

    setState(() {
      this.category = pred;
    });

    print("predict : ");
    print(category!.label);

    print("confidence : ");
    print(category!.score);

    if (category!.label == 'add') {
      meaningThai = 'บวก';
    } else if (category!.label == 'animal') {
      meaningThai = 'สัตว์';
    } else if (category!.label == 'bowl') {
      meaningThai = 'ถ้วย';
    } else if (category!.label == 'buffalo') {
      meaningThai = 'กระบือ';
    } else if (category!.label == 'care') {
      meaningThai = 'ห่วงใย';
    } else if (category!.label == 'cat') {
      meaningThai = 'แมว';
    } else if (category!.label == 'chest') {
      meaningThai = 'อก';
    } else if (category!.label == 'cow') {
      meaningThai = 'วัว';
    } else if (category!.label == 'deer') {
      meaningThai = 'กวาง';
    } else if (category!.label == 'divide') {
      meaningThai = 'หาร';
    } else if (category!.label == 'double') {
      meaningThai = 'ทวีคูณ';
    } else if (category!.label == 'eight') {
      meaningThai = 'เลข 8';
    } else if (category!.label == 'elbow') {
      meaningThai = 'ข้อศอก';
    } else if (category!.label == 'eye') {
      meaningThai = 'ตา';
    } else if (category!.label == 'finger') {
      meaningThai = 'นิ้ว';
    } else if (category!.label == 'five') {
      meaningThai = 'เลข 5';
    } else if (category!.label == 'four') {
      meaningThai = 'เลข 4';
    } else if (category!.label == 'gun') {
      meaningThai = 'ปืน';
    } else if (category!.label == 'hair') {
      meaningThai = 'ผม';
    } else if (category!.label == 'hand') {
      meaningThai = 'มือ';
    } else if (category!.label == 'he') {
      meaningThai = 'เขา';
    } else if (category!.label == 'head') {
      meaningThai = 'ศีรษะ';
    } else if (category!.label == 'love') {
      meaningThai = 'รัก';
    } else if (category!.label == 'me') {
      meaningThai = 'ฉัน';
    } else if (category!.label == 'meditate') {
      meaningThai = 'นั่งสมาธิ';
    } else if (category!.label == 'mushroom') {
      meaningThai = 'เห็ด';
    } else if (category!.label == 'nine') {
      meaningThai = 'เลข 9';
    } else if (category!.label == 'noon') {
      meaningThai = 'เที่ยงวัน';
    } else if (category!.label == 'nose') {
      meaningThai = 'จมูก';
    } else if (category!.label == 'one') {
      meaningThai = 'เลข 1';
    } else if (category!.label == 'rat') {
      meaningThai = 'หนู';
    } else if (category!.label == 'remember') {
      meaningThai = 'จดจำ';
    } else if (category!.label == 'rhinoceros') {
      meaningThai = 'แรด';
    } else if (category!.label == 'salty') {
      meaningThai = 'เค็ม';
    } else if (category!.label == 'serve') {
      meaningThai = 'บริการ';
    } else if (category!.label == 'seven') {
      meaningThai = 'เลข 7';
    } else if (category!.label == 'shirt') {
      meaningThai = 'เสื้อ';
    } else if (category!.label == 'shoulder') {
      meaningThai = 'ไหล่';
    } else if (category!.label == 'sick') {
      meaningThai = 'ป่วย';
    } else if (category!.label == 'six') {
      meaningThai = 'เลข 6';
    } else if (category!.label == 'soldier') {
      meaningThai = 'ทหาร';
    } else if (category!.label == 'teeth') {
      meaningThai = 'ฟัน';
    } else if (category!.label == 'three') {
      meaningThai = 'เลข 3';
    } else if (category!.label == 'tiger') {
      meaningThai = 'เสือ';
    } else if (category!.label == 'time') {
      meaningThai = 'เวลา';
    } else if (category!.label == 'tongue') {
      meaningThai = 'ลิ้น';
    } else if (category!.label == 'two') {
      meaningThai = 'เลข 2';
    } else if (category!.label == 'wedding') {
      meaningThai = 'งานแต่งงาน';
    } else if (category!.label == 'win') {
      meaningThai = 'ชนะ';
    } else if (category!.label == 'zero') {
      meaningThai = 'เลข 0';
    }

    print('------------stop------------');

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child('camera_pictures/image_' + DateTime.now().toString());
    await ref.putFile(_image!);
    String URLL = await ref.getDownloadURL();

    print('imageURLL = ');
    print(URLL);

    CollectionReference histories =
        FirebaseFirestore.instance.collection('History');
    histories.add({
      'category': "หมวดเทส",
      'imageURL': URLL,
      'vocab': meaningThai,
      'timestamp': DateTime.now()
    });

    print('---------- add history complete -------------');

    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          image: image,
          //name: category!.label,
          name: meaningThai,
          camera: widget.camera,
        ),
      ),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("----Result Page-----");

    final meaning = Positioned(
        top: 20,
        child: Container(
          width: screenSize.width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(widget.name,
                    style: TextStyle(
                      fontFamily: 'Anakotmai',
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    )),
              )
            ],
          ),
        ));

    final reButton = Positioned(
        bottom: 20,
        child: Container(
            width: screenSize.width,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color.fromRGBO(255, 255, 255, 0),
                    child: InkWell(
                        onTap: () {
                          getImage();
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        hoverColor: Color.fromRGBO(255, 255, 255, 1),
                        child: Container(
                          padding: const EdgeInsets.only(top: 9),
                          width: 180,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.75),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Text(
                            'เลือกภาพเพิ่มเติม',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Anakotmai',
                              color: Color(0xff2b2b2b),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                  )
                ])));

    return Scaffold(
      backgroundColor: Color(0xF7F7F7FF),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(camera: widget.camera)));
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            title: Text('THSL Translate: Import image',
                style: TextStyle(
                  fontFamily: 'Anakotmai',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
            backgroundColor: Color(0xFF1821AE),
          )),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                width: screenSize.width,
                height: screenSize.width,
                color: Color(0xFFEBEEF5),
                child: Center(
                  child: Container(
                    width: screenSize.width,
                    height: screenSize.width,
                    child: Image.file(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              meaning,
              reButton
            ],
          ),
          SizedBox(
            height: 20,
          ),
          haveHistory
              ? Row(
                  children: [
                    Container(
                      width: screenSize.width * 0.70,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        "ประวัติการแปลของคุณ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Anakotmai',
                          color: Color(0xff2b2b2b),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: screenSize.width * 0.30,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(right: 25),
                      child: Text(
                        'ลบทั้งหมด',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Anakotmai',
                          color: Color(0xffE74C3C),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
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
