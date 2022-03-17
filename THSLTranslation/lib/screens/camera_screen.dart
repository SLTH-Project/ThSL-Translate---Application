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
  const CameraPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

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

    /*return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          image: image,
          name: category!.label,
          camera: widget.camera,
        ),
      ),
    );*/
  }

  @override
  void dispose() {
    Tflite.close();
    controller.dispose();
    super.dispose();
  }

  bool yes = false;
  String location = '';
  String categoryName = '';
  bool meaningVocab = false;
  bool stop = false;
  String meaningThai = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    /*final capture = Positioned(
        bottom: 20,
        left: 100,
        child: IconButton(
            onPressed: () async {
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
            },
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 50,
            )));*/

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
                color: Color(0xffd1d3ef),
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
                  child: Text('หยุดการแปลชั่วคราว',
                      style: TextStyle(
                        fontFamily: 'Anakotmai',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () {
                  setState(() async {
                    stop = !stop;
                    print('------------stop------------');

                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference ref = storage.ref().child(
                        'camera_pictures/image_' + DateTime.now().toString());
                    await ref.putFile(_image!);
                    String URLL = await ref.getDownloadURL();

                    print('imageURLL = ');
                    print(URLL);

                    CollectionReference histories =
                        FirebaseFirestore.instance.collection('History');
                    histories.add({
                      'category': "หมวดเทส",
                      'imageURL': URLL,
                      'vocab': meaningThai
                    });

                    print('---------- add history complete -------------');
                  });
                },
              )
            ],
          ),
        ));

    /*final gallery = Positioned(
        bottom: 20,
        right: 100,
        child: IconButton(
            onPressed: getImage,
            icon: Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 50,
            )));*/

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
                          //print('click category = ');
                          //print(yes);
                          location = document["location"];
                          categoryName = "     <  " + document["name"];
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
                      //return;
                    },
                    child: Text(
                      yes ? categoryName : '     คลังภาษามือไทย 100 คำ',
                      style: TextStyle(
                        fontFamily: 'Anakotmai',
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
      )
      /*PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(camera: widget.camera)));
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text('THSL Translate',
              style: TextStyle(
                fontFamily: 'Anakotmai',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Color(0xFF1821AE),
        ),
      )*/
      ,
      body: SizedBox.expand(
          child: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [camera],
          ),
        ),
        bottomSwipeUp
      ])),
    );
  }
}
