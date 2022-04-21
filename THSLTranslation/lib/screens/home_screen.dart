//import 'dart:html';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thsltranslation/screens/camera_screen.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:thsltranslation/screens/result_screen.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:thsltranslation/models/classifier.dart';
import 'package:thsltranslation/models/classifier_float.dart';
import 'package:logger/logger.dart';

/*class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: '     วิธีใช้งาน',
      expandedValue: 'เขียนไปก็ไม่ขึ้น',
    );
  });
}*/

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  /*late CameraController controller;
  late Future<void> _initializeControllerFuture;

  final List<Item> _data = generateItems(1);

  List _outputs = [];
  late File _image;
  bool _loading = false;*/

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
  bool haveHistory = false;

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

    print('--------save history to firebase------------');

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

    var snapshot = await FirebaseFirestore.instance.collection('History').get();
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

    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          image: image,
          name: meaningThai,
          camera: widget.camera,
          //history: haveHistory,
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
    print("==================================================================");
    print('START : click category = ');
    print(yes);

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

    /*final panel = ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.all(1),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue,
                  style: TextStyle(
                    fontFamily: 'Anakotmai',
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
            );
          },
          body: Container(
              height: 150,
              color: Colors.white,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('HowTo')
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
                          return Container(
                              margin:
                                  EdgeInsets.only(left: 24, top: 5, bottom: 25),
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
                              width: 200,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      document["imageURL"],
                                      height: 65,
                                    ),
                                    Text(
                                      document["detail1"],
                                      style: TextStyle(
                                        fontFamily: 'Anakotmai',
                                        color: Color(0xff2b2b2b),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      document["detail2"],
                                      style: TextStyle(
                                        fontFamily: 'Anakotmai',
                                        color: Color(0xff2b2b2b),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ]));
                        }).toList(),
                      );
                    }
                  })),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );*/

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

    final intro = Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Text("แปลท่าทาง พร้อมเรียนรู้คำศัพท์ภาษามือไทย",
                style: TextStyle(
                  fontFamily: 'Anakotmai',
                  color: Color(0xFF2B2B2B),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                )),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 5),
            child: Text(
                "โดยคลังคำศัพท์ภาษามือไทยพื้นฐานในชีวิตประจำวันมากถึง 100 คำ",
                style: TextStyle(
                  fontFamily: 'Anakotmai',
                  color: Color(0xFF828280),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
          )
        ],
      ),
    );

    final howTo = Container(
        height: 118,
        color: Colors.white,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('HowTo').snapshots(),
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
                    return Container(
                        padding: EdgeInsets.only(top: 16, bottom: 19),
                        margin: EdgeInsets.only(left: 22),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFF1812AE),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x202b2b2b),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 1))
                            ]),
                        width: 229,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  document["imageURL"],
                                  height: 65,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      document["detail1"],
                                      style: TextStyle(
                                        fontFamily: 'Anakotmai',
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      document["detail2"],
                                      style: TextStyle(
                                        fontFamily: 'Anakotmai',
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      document["detail3"],
                                      style: TextStyle(
                                        fontFamily: 'Anakotmai',
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      document["detail4"],
                                      style: TextStyle(
                                        fontFamily: 'Anakotmai',
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]));
                  }).toList(),
                );
              }
            }));

    final choices = Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0x202b2b2b),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 1))
      ]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraPage(
                                  camera: widget.camera,
                                  history: haveHistory,
                                )));
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Color(0xFF1821AE),
                    size: 25,
                  )),
              Text("Camera",
                  style: TextStyle(
                    fontFamily: 'Anakotmai',
                    color: Color(0xFF2B2B2B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: getImage,
                  icon: Icon(
                    Icons.photo_library,
                    color: Color(0xFF1821AE),
                    size: 25,
                  )),
              Text("Gallery",
                  style: TextStyle(
                    fontFamily: 'Anakotmai',
                    color: Color(0xFF2B2B2B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFEBEEF5),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            leading: Container(),
            centerTitle: true,
            title: Text('THSL Translate',
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
            children: [
              intro,
              howTo,
              choices,
            ],
          ),
        ),
        bottomSwipeUp
      ])),
    );
  }
}
