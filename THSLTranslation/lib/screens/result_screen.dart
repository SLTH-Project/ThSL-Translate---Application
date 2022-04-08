// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:thsltranslation/screens/home_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
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
  String categoryThai = '';

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
      categoryThai = 'คณิตศาสตร์';
    } else if (category!.label == 'animal') {
      meaningThai = 'สัตว์';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'bowl') {
      meaningThai = 'ถ้วย';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'buffalo') {
      meaningThai = 'กระบือ';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'care') {
      meaningThai = 'ห่วงใย';
      categoryThai = 'อาการ';
    } else if (category!.label == 'cat') {
      meaningThai = 'แมว';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'chest') {
      meaningThai = 'อก';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'cow') {
      meaningThai = 'วัว';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'deer') {
      meaningThai = 'กวาง';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'divide') {
      meaningThai = 'หาร';
      categoryThai = 'คณิตศาสตร์';
    } else if (category!.label == 'double') {
      meaningThai = 'ทวีคูณ';
      categoryThai = 'คณิตศาสตร์';
    } else if (category!.label == 'eight') {
      meaningThai = 'เลข 8';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'elbow') {
      meaningThai = 'ข้อศอก';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'eye') {
      meaningThai = 'ตา';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'finger') {
      meaningThai = 'นิ้ว';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'five') {
      meaningThai = 'เลข 5';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'four') {
      meaningThai = 'เลข 4';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'gun') {
      meaningThai = 'ปืน';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'hair') {
      meaningThai = 'ผม';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'hand') {
      meaningThai = 'มือ';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'he') {
      meaningThai = 'เขา';
      categoryThai = 'คำสรรพนาม';
    } else if (category!.label == 'head') {
      meaningThai = 'ศีรษะ';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'love') {
      meaningThai = 'รัก';
      categoryThai = 'อาการ';
    } else if (category!.label == 'me') {
      meaningThai = 'ฉัน';
      categoryThai = 'คำสรรพนาม';
    } else if (category!.label == 'meditate') {
      meaningThai = 'นั่งสมาธิ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'mushroom') {
      meaningThai = 'เห็ด';
      categoryThai = 'อาหาร';
    } else if (category!.label == 'nine') {
      meaningThai = 'เลข 9';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'noon') {
      meaningThai = 'เที่ยงวัน';
      categoryThai = 'เวลา';
    } else if (category!.label == 'nose') {
      meaningThai = 'จมูก';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'one') {
      meaningThai = 'เลข 1';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'rat') {
      meaningThai = 'หนู';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'remember') {
      meaningThai = 'จดจำ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'rhinoceros') {
      meaningThai = 'แรด';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'salty') {
      meaningThai = 'เค็ม';
      categoryThai = 'อาการ';
    } else if (category!.label == 'serve') {
      meaningThai = 'บริการ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'seven') {
      meaningThai = 'เลข 7';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'shirt') {
      meaningThai = 'เสื้อ';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'shoulder') {
      meaningThai = 'ไหล่';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'sick') {
      meaningThai = 'ป่วย';
      categoryThai = 'อาการ';
    } else if (category!.label == 'six') {
      meaningThai = 'เลข 6';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'soldier') {
      meaningThai = 'ทหาร';
      categoryThai = 'อื่น ๆ';
    } else if (category!.label == 'teeth') {
      meaningThai = 'ฟัน';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'three') {
      meaningThai = 'เลข 3';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'tiger') {
      meaningThai = 'เสือ';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'time') {
      meaningThai = 'เวลา';
      categoryThai = 'เวลา';
    } else if (category!.label == 'tongue') {
      meaningThai = 'ลิ้น';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'two') {
      meaningThai = 'เลข 2';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'wedding') {
      meaningThai = 'งานแต่งงาน';
      categoryThai = 'สถานที่';
    } else if (category!.label == 'win') {
      meaningThai = 'ชนะ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'zero') {
      meaningThai = 'เลข 0';
      categoryThai = 'ตัวเลข';
    } else if (category!.label == 'airplane') {
      meaningThai = 'เครื่องบิน';
      categoryThai = 'ยานพาหนะ';
    } else if (category!.label == 'angry') {
      meaningThai = 'โกรธ';
      categoryThai = 'อาการ';
    } else if (category!.label == 'bat') {
      meaningThai = 'ค้างคาว';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'bite') {
      meaningThai = 'กัด';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'bow the head') {
      meaningThai = 'ก้มศีรษะ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'bread') {
      meaningThai = 'ขนมปัง';
      categoryThai = 'อาหาร';
    } else if (category!.label == 'cockle') {
      meaningThai = 'หอยแครง';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'cough') {
      meaningThai = 'ไอ';
      categoryThai = 'อาการ';
    } else if (category!.label == 'crab') {
      meaningThai = 'ปู';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'crutches') {
      meaningThai = 'ไม้ค้ำยัน';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'disease') {
      meaningThai = 'โรค';
      categoryThai = 'อาการ';
    } else if (category!.label == 'ear') {
      meaningThai = 'หู';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'eyelash') {
      meaningThai = 'ขนตา';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'feeling') {
      meaningThai = 'ความรู้สึก';
      categoryThai = 'อาการ';
    } else if (category!.label == 'fine') {
      meaningThai = 'สบาย';
      categoryThai = 'อาการ';
    } else if (category!.label == 'fish sauce') {
      meaningThai = 'น้ำปลา';
      categoryThai = 'อาหาร';
    } else if (category!.label == 'food') {
      meaningThai = 'อาหาร';
      categoryThai = 'อาหาร';
    } else if (category!.label == 'full') {
      meaningThai = 'อิ่ม';
      categoryThai = 'อาการ';
    } else if (category!.label == 'ginger') {
      meaningThai = 'ขิง';
      categoryThai = 'อาหาร';
    } else if (category!.label == 'glass') {
      meaningThai = 'แก้วน้ำ';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'glasses') {
      meaningThai = 'แว่นตา';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'good luck') {
      meaningThai = 'โชคดี';
      categoryThai = 'อื่น ๆ';
    } else if (category!.label == 'hotel') {
      meaningThai = 'โรงแรม';
      categoryThai = 'สถานที่';
    } else if (category!.label == 'iron') {
      meaningThai = 'เตารีด';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'key') {
      meaningThai = 'กุญแจ';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'kiss') {
      meaningThai = 'จูบ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'lie prone') {
      meaningThai = 'นอนคว่ำ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'lie still') {
      meaningThai = 'นอนนิ่ง';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'location') {
      meaningThai = 'สถานที่';
      categoryThai = 'สถานที่';
    } else if (category!.label == 'meet') {
      meaningThai = 'พบ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'milk') {
      meaningThai = 'นม';
      categoryThai = 'อาหาร';
    } else if (category!.label == 'name') {
      meaningThai = 'ชื่อ';
      categoryThai = 'คำสรรพนาม';
    } else if (category!.label == 'now') {
      meaningThai = 'ขณะนี้';
      categoryThai = 'เวลา';
    } else if (category!.label == 'open mouth') {
      meaningThai = 'อ้าปาก';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'person') {
      meaningThai = 'คน/บุคคล';
      categoryThai = 'คำสรรพนาม';
    } else if (category!.label == 'pregnant') {
      meaningThai = 'ตั้งครรภ์';
      categoryThai = 'อาการ';
    } else if (category!.label == 'prevent') {
      meaningThai = 'ป้องกัน';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'request') {
      meaningThai = 'ขอ';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'ride a motorcycle') {
      meaningThai = 'ขี่มอเตอร์ไซต์';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'sailboat') {
      meaningThai = 'เรือใบ';
      categoryThai = 'ยานพาหนะ';
    } else if (category!.label == 'snail') {
      meaningThai = 'หอยทาก';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'soup') {
      meaningThai = 'แกงจืด';
      categoryThai = 'อาหาร';
    } else if (category!.label == 'spoon') {
      meaningThai = 'ช้อน';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'stand') {
      meaningThai = 'ยืน';
      categoryThai = 'การกระทำ';
    } else if (category!.label == 'strong') {
      meaningThai = 'แข็งแรง';
      categoryThai = 'อาการ';
    } else if (category!.label == 'telephone') {
      meaningThai = 'โทรศัพท์';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'television') {
      meaningThai = 'โทรทัศน์';
      categoryThai = 'สิ่งของ';
    } else if (category!.label == 'tilapia') {
      meaningThai = 'ปลานิล';
      categoryThai = 'สัตว์';
    } else if (category!.label == 'waist') {
      meaningThai = 'เอว';
      categoryThai = 'ร่างกาย';
    } else if (category!.label == 'water') {
      meaningThai = 'น้ำ';
      categoryThai = 'อาหาร';
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
      'category': categoryThai,
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

  bool yes = false;
  String location = '';
  Row rowCategoryName = Row();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("----Result Page-----");

    setCategoryName(Icon icon, Text textt) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 25,
          ),
          icon,
          SizedBox(
            width: 10,
          ),
          textt
        ],
      );
    }

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

    final rowCatagory = Container(
        height: 110,
        color: Colors.white,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('CategoryPic')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((document) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          yes = true;
                          //print('click category = ');
                          //print(yes);
                          location = document["location"];
                          rowCategoryName = setCategoryName(
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black87,
                                size: 20,
                              ),
                              Text(
                                document["name"],
                                style: TextStyle(
                                  fontFamily: 'Anakotmai',
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 24, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x202b2b2b),
                                  spreadRadius: 3,
                                  blurRadius: 4,
                                  offset: Offset(0, 1))
                            ]),
                        width: 90,
                        child: Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Image.network(
                                document["imageURL"],
                                height: 70,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                    height: 40,
                                    width: 98,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      //color: Colors.indigo[50],
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(1),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                document["name"],
                                                style: TextStyle(
                                                  fontFamily: 'Anakotmai',
                                                  color: Color(0xff2b2b2b),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ]))),
                              )
                            ]),
                      ),
                    );
                  }).toList(),
                );
              }
            }));

    rowVocab(String locate) {
      return Container(
          height: 110,
          color: Colors.white,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(locate).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      return InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 1, 1, 0),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              alignment:
                                                  FractionalOffset.topRight,
                                              child: GestureDetector(
                                                child: Icon(
                                                  Icons.clear,
                                                  color: Color(0xffAEAEAB),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          document["name"],
                                          style: TextStyle(
                                            fontFamily: 'Anakotmai',
                                            color: Color(0xff2b2b2b),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ]),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Image(
                                          image: NetworkImage(
                                              document["imageURL"]),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          document["detail"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Anakotmai',
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 24, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x202b2b2b),
                                    spreadRadius: 3,
                                    blurRadius: 4,
                                    offset: Offset(0, 1))
                              ]),
                          width: 90,
                          child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Image.network(
                                  document["imageURL"],
                                  height: 70,
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                      height: 40,
                                      width: 98,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //color: Colors.indigo[50],
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.all(1),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  document["name"],
                                                  style: TextStyle(
                                                    fontFamily: 'Anakotmai',
                                                    color: Color(0xff2b2b2b),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ]))),
                                )
                              ]),
                        ),
                      );
                    }).toList(),
                  );
                }
              }));
    }

    final bottomSwipeUp = SizedBox.expand(
      child: DraggableScrollableSheet(
          initialChildSize: 0.12,
          minChildSize: 0.12,
          maxChildSize: 0.4,
          builder: (BuildContext context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
              child: ListView(
                controller: scrollController,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 8,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          yes = false;
                          //print('click to back to category (false) = ');
                          //print(yes);
                        });
                        //return;
                      },
                      child: yes
                          ? rowCategoryName
                          : setCategoryName(
                              Icon(
                                Icons.menu_book,
                                color: Colors.black87,
                                size: 20,
                              ),
                              Text(
                                'คลังภาษามือไทย 100 คำ',
                                style: TextStyle(
                                  fontFamily: 'Anakotmai',
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )),
                  SizedBox(
                    height: 15,
                  ),
                  yes ? rowVocab(location) : rowCatagory,
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          }),
    );

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
        body: SizedBox.expand(
            child: Stack(children: <Widget>[
          SingleChildScrollView(
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
          bottomSwipeUp
        ])));
  }
}
