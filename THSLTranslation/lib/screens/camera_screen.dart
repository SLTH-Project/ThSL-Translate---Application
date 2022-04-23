import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image/image.dart' as img;
import 'package:thsltranslation/models/classifier.dart';
import 'package:thsltranslation/models/classifier_float.dart';
import 'package:logger/logger.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  //List _outputs = [];
  //late File _image;
  //bool _loading = false;

  //----------Classify---------------------
  late Classifier _classifier;

  var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  img.Image? fox;

  Category? category;
  //----------------------------------------

  bool yes = false;
  String location = '';
  Row rowCategoryName = Row();
  bool meaningVocab = false;
  bool stop = false;
  String meaningThai = '';
  String categoryThai = '';
  bool haveHistory = false;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierFloat();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = controller.initialize();

    meaningVocab = false;
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

    meaningVocab = true;

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
  }

  @override
  void dispose() {
    Tflite.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    FirebaseFirestore.instance.collection('History').get().then((snapshot) {
      if (snapshot.docs.isNotEmpty == true) {
        haveHistory = true;
        print('---------1have history = -----------');
        print(haveHistory);
      } else {
        haveHistory = false;
        print('---------1have history = -----------');
        print(haveHistory);
      }
    });

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
                child: Text(meaningVocab ? meaningThai : "",
                    style: TextStyle(
                      fontFamily: 'Anakotmai',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
              )
            ],
          ),
        ));

    final stopButton = Positioned(
        bottom: 20,
        child: Container(
          width: screenSize.width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff7f7f7),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black87,
                            spreadRadius: 0.01,
                            blurRadius: 7.5,
                            offset: Offset(0, 2))
                      ]),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(stop ? 'ดำเนินการแปลต่อ' : 'หยุดการแปลชั่วคราว',
                      style: TextStyle(
                        fontFamily: 'Anakotmai',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () async {
                  print('------------stop------------');
                  setState(() {
                    stop = !stop;
                  });

                  print('stop = ');
                  print(stop);

                  if (stop == true) {
                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference ref = storage.ref().child(
                        'camera_pictures/image_' + DateTime.now().toString());
                    await ref.putFile(_image!);
                    String URLL = await ref.getDownloadURL();

                    CollectionReference histories =
                        FirebaseFirestore.instance.collection('History');
                    histories.add({
                      'category': categoryThai,
                      'imageURL': URLL,
                      'vocab': meaningThai,
                      'timestamp': DateTime.now()
                    });

                    print('---------- add history complete -------------');
                  }

                  var snapshot = await FirebaseFirestore.instance
                      .collection('History')
                      .get();
                  setState(() {
                    if (snapshot.docs.isNotEmpty == true) {
                      haveHistory = true;
                      print('---------2have history = -----------');
                      print(haveHistory);
                    } else {
                      haveHistory = false;
                      print('---------2have history = -----------');
                      print(haveHistory);
                    }
                  });
                },
              )
            ],
          ),
        ));

    final camera = Stack(
      children: <Widget>[
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
              width: screenSize.width,
              height: screenSize.width,
              child: CameraPreview(controller)),
        ),
        Image(
          image: AssetImage('assets/images/frame-camera-front.png'),
        ),
        Image(
          image: AssetImage('assets/images/frame-camera-square.png'),
          height: screenSize.width,
          width: screenSize.width,
        ),
        meaningVocab ? meaning : Container(),
        stopButton
      ],
    );

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
                        });
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

    if (stop == false) {
      print('----camera realtime detect----');
      Timer(Duration(milliseconds: 250), () async {
        //after 0.25 seconds this will be called,
        try {
          await _initializeControllerFuture;
          final imageFromCamera = await controller.takePicture();
          setState(() {
            _image = File(imageFromCamera.path);
            print("----capture----");
            _predict(_image!);
          });
        } catch (e) {
          print(e);
        }
      });
    }

    final historyColumn = Container(
        height: screenSize.height * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('History')
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.map((document) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  title: Column(
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
                                      Center(
                                        child: Text(
                                          document["vocab"],
                                          style: TextStyle(
                                            fontFamily: 'Anakotmai',
                                            color: Color(0xff2b2b2b),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "หมวด" + document["category"],
                                          style: TextStyle(
                                            fontFamily: 'Anakotmai',
                                            color: Color(0xff828280),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 300,
                                          height: 230,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              document["imageURL"],
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('History')
                                                .doc(document.id)
                                                .delete();
                                            FirebaseStorage.instance
                                                .refFromURL(
                                                    document["imageURL"])
                                                .delete();
                                          });

                                          var snapshot = await FirebaseFirestore
                                              .instance
                                              .collection('History')
                                              .get();
                                          setState(() {
                                            if (snapshot.docs.isNotEmpty ==
                                                true) {
                                              haveHistory = true;
                                              print(
                                                  '---------5have history = -----------');
                                              print(haveHistory);
                                            } else {
                                              haveHistory = false;
                                              print(
                                                  '---------5have history = -----------');
                                              print(haveHistory);
                                            }
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Color(0xffE74C3C),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 14),
                                            child: Center(
                                              child: Text('ลบ',
                                                  style: TextStyle(
                                                    fontFamily: 'Anakotmai',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            )),
                                      )
                                    ],
                                  ));
                            });
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x202b2b2b),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 1))
                              ]),
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            document["imageURL"],
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            document["vocab"],
                                            style: TextStyle(
                                              fontFamily: 'Anakotmai',
                                              color: Color(0xff555555),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "หมวด" + document["category"],
                                            style: TextStyle(
                                              fontFamily: 'Anakotmai',
                                              color: Color(0xff828280),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 1, right: 1),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        alignment: FractionalOffset.topRight,
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.clear,
                                            color: Color(0xffAEAEAB),
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              FirebaseFirestore.instance
                                                  .collection('History')
                                                  .doc(document.id)
                                                  .delete();
                                              FirebaseStorage.instance
                                                  .refFromURL(
                                                      document["imageURL"])
                                                  .delete();
                                            });
                                            var snapshot =
                                                await FirebaseFirestore.instance
                                                    .collection('History')
                                                    .get();
                                            setState(() {
                                              if (snapshot.docs.isNotEmpty ==
                                                  true) {
                                                haveHistory = true;
                                                print(
                                                    '---------3have history = -----------');
                                                print(haveHistory);
                                              } else {
                                                haveHistory = false;
                                                print(
                                                    '---------3have history = -----------');
                                                print(haveHistory);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ])),
                    );
                    /*;*/
                  }).toList(),
                );
              }
            }));

    return Scaffold(
      backgroundColor: Color(0xFFEBEEF5),
      appBar: AppBar(
        title: Text('THSL Translate',
            style: TextStyle(
              fontFamily: 'Anakotmai',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Color(0xFF1821AE),
      ),
      body: SizedBox.expand(
          child: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              camera,
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
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        title: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                          ],
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 61,
                                              height: 61,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFFF5F5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Icon(
                                                Icons.delete,
                                                size: 40,
                                                color: Color(0xffE74C3C),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            Text('ยืนยันการลบประวัติ',
                                                style: TextStyle(
                                                  fontFamily: 'Anakotmai',
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            Text('การแปลภาษามือไทยทั้งหมด',
                                                style: TextStyle(
                                                  fontFamily: 'Anakotmai',
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            SizedBox(
                                              height: 36,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('History')
                                                    .get()
                                                    .then((snapshot) async {
                                                  for (DocumentSnapshot ds
                                                      in snapshot.docs) {
                                                    await ds.reference.delete();
                                                  }
                                                });

                                                print('delete all');

                                                var snapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('History')
                                                        .get();
                                                setState(() {
                                                  if (snapshot
                                                          .docs.isNotEmpty ==
                                                      true) {
                                                    haveHistory = true;
                                                    print(
                                                        '---------4have history = -----------');
                                                    print(haveHistory);
                                                  } else {
                                                    haveHistory = false;
                                                    print(
                                                        '---------4have history = -----------');
                                                    print(haveHistory);
                                                  }
                                                });

                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffE74C3C),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 14),
                                                child: Center(
                                                  child: Text('ลบทั้งหมด',
                                                      style: TextStyle(
                                                        fontFamily: 'Anakotmai',
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  });
                            },
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
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              historyColumn,
              SizedBox(
                height: 75,
              ),
            ],
          ),
        ),
        bottomSwipeUp
      ])),
    );
  }
}
