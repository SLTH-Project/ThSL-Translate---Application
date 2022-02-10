import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:thsltranslation/screens/result_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'package:image/image.dart' as img;
import 'package:thsltranslation/models/classifier.dart';
import 'package:thsltranslation/models/classifier_float.dart';
import 'package:logger/logger.dart';
import 'package:thsltranslation/screens/home_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final capture = Positioned(
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
            )));

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
                child: Text(meaningVocab ? category!.label : "",
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

    final gallery = Positioned(
        bottom: 20,
        right: 100,
        child: IconButton(
            onPressed: getImage,
            icon: Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 50,
            )));

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
        //capture,
        //gallery
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
