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

  bool yes = false;
  String location = '';
  Row rowCategoryName = Row();

  @override
  Widget build(BuildContext context) {
    print("==================================================================");
    print('START : click category = ');
    print(yes);

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
      //print('----in rowVocab----');

      //print('location = ');
      //print(locate);

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
                          //print('click to show pic');
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: Center(
                                    child: Text(
                                      document["name"],
                                      style: TextStyle(
                                        fontFamily: 'Anakotmai',
                                        color: Color(0xff2b2b2b),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  content: Container(
                                    child: Image(
                                      image: NetworkImage(document["imageURL"]),
                                    ),
                                  )));
                        },
                        /*onHover: () {

                        },*/
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
        //padding: EdgeInsets.only(bottom: 10),
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
                            builder: (context) =>
                                CameraPage(camera: widget.camera)));
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
