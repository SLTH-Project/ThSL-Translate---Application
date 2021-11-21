//import 'dart:html';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:thsltranslation/screens/result_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Item {
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
      headerValue: 'วิธีใช้งาน',
      expandedValue: 'เขียนไปก็ไม่ขึ้น',
    );
  });
}

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
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  final List<Item> _data = generateItems(1);

  List _outputs = [];
  //late File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = controller.initialize();

    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_B_rmsProp.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  classifyImage(File image) async {
    print("classifyImage running");
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 127.5, //0
        imageStd: 127.5, //255.0
        numResults: 3,
        threshold: 0.1, //0.2
        asynch: true);

    print("output = ");
    print(output);

    if (output!.isEmpty) {
      var tmp = {
        "confidence": 0,
        "index": 100,
        "label": "Can't identify",
      };
      output = [...output, tmp];
      print("output after change in if = ");
      print(output);
    }

    setState(() {
      _loading = false;
      _outputs = output!;
    });

    print("classifyImage set state complete");
    print("==================================================================");
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          image: image,
          name: _outputs[0]["label"],
          camera: widget.camera,
        ),
      ),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    controller.dispose();
    super.dispose();
  }

  pickImage() async {
    print("-----------------------------------------------------------");
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image == null) {
      print("image is null");
      return null;
    }
    setState(() async {
      _loading = true;
      File image = File(_image.path);

      var decodedImage = await decodeImageFromList(image.readAsBytesSync());
      print("image width : ");
      print(decodedImage.width);
      print("image height : ");
      print(decodedImage.height);

      /*ImageProcessor imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
          .build();

      TensorImage tensorImage = TensorImage.fromFile(image);

      tensorImage = imageProcessor.process(tensorImage);*/

      classifyImage(image);
      print("after classify");
    });
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  bool yes = false;
  String location = '';
  String categoryName = '';

  @override
  Widget build(BuildContext context) {
    print("==================================================================");
    print('START : click category = ');
    print(yes);

    final screenSize = MediaQuery.of(context).size;

    final panel = ExpansionPanelList(
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
                    fontSize: 18,
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
                                  EdgeInsets.only(left: 24, top: 5, bottom: 20),
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
                              width: 259,
                              height: 134,
                              child: Column(children: <Widget>[
                                Image.network(
                                  document["imageURL"],
                                  height: 63,
                                ),
                                Text(
                                  document["detail1"],
                                  style: TextStyle(
                                    fontFamily: 'Anakotmai',
                                    color: Color(0xff2b2b2b),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  document["detail2"],
                                  style: TextStyle(
                                    fontFamily: 'Anakotmai',
                                    color: Color(0xff2b2b2b),
                                    fontSize: 16,
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
    );

    final rowCatagory = Container(
        height: 180,
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
                        //return;
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 24, top: 5, bottom: 5),
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
                        width: 144,
                        child: Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Image.network(
                                document["imageURL"],
                                height: 120,
                              ),
                              Positioned(
                                bottom: 10,
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
                                                  fontSize: 18,
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
          height: 180,
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
                                    content: Image(
                                        image:
                                            NetworkImage(document["imageURL"])),
                                  ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 24, top: 5, bottom: 5),
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
                          width: 144,
                          child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Image.network(
                                  document["imageURL"],
                                  height: 120,
                                ),
                                Positioned(
                                  bottom: 10,
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
                                                    fontSize: 18,
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

    final capture = Positioned(
        bottom: 20,
        child: Container(
            width: screenSize.width,
            alignment: Alignment.center,
            //color: Colors.white,
            child: IconButton(
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    final img = await controller.takePicture();
                    classifyImage(File(img.path));
                    /*await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          image: File(img.path),
                          name: ,
                        ),
                      ),
                    );*/
                  } catch (e) {
                    print(e);
                  }
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 50,
                ))));

    final camera = Stack(
      children: <Widget>[
        Container(
          width: screenSize.width,
          height: screenSize.width,
          child: ClipRRect(
            child: OverflowBox(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                    width: screenSize.width,
                    height: screenSize.width,
                    child: CameraPreview(controller)),
              ),
            ),
          ),
        ),
        Image(
          image: AssetImage('assets/images/frame-camera-front.png'),
        ),
        Image(
          image: AssetImage('assets/images/frame-camera-square.png'),
          height: screenSize.width,
          width: screenSize.width,
        ),
        capture
      ],
    );

    final bottomSwipeUp = SizedBox.expand(
      child: DraggableScrollableSheet(
          initialChildSize: 0.1,
          minChildSize: 0.1,
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
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  /*Text(
                    yes ? categoryName : '     คลังภาษามือไทย 100 คำ',
                    style: TextStyle(
                      fontFamily: 'Anakotmai',
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),*/
                  SizedBox(
                    height: 15,
                  ),
                  yes ? rowVocab(location) : rowCatagory,
                  SizedBox(
                    height: 10,
                  ),
                  //rowCatagory
                ],
              ),
            );
          }),
    );

    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: Color(0xFFEBEEF5),
                appBar: AppBar(
                  leading: Container(),
                  centerTitle: true,
                  title: Text('THSL Translate',
                      style: TextStyle(
                        fontFamily: 'Anakotmai',
                        color: Color(0xFF2B2B2B),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      )),
                  backgroundColor: Colors.white,
                ),
                body: SizedBox.expand(
                    child: Stack(children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        camera,
                        panel,
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                  bottomSwipeUp
                ])),
                floatingActionButton: FloatingActionButton(
                  tooltip: 'Pick Image',
                  onPressed: pickImage,
                  child: Icon(
                    Icons.add_a_photo,
                    size: 20,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.amber,
                ));
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

//Camera
/*FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(controller);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),*/

/*final CollectionReference actionCollection = FirebaseFirestore.instance.collection('Category/action/actionList');
    final CollectionReference animalCollection = FirebaseFirestore.instance.collection('Category/animal/animalList');
    final CollectionReference bodyCollection = FirebaseFirestore.instance.collection('Category/body/bodyList');
    final CollectionReference countryCollection =
        FirebaseFirestore.instance.collection('Category/country/countryList');
    final CollectionReference feelCollection =
        FirebaseFirestore.instance.collection('Category/feel/feelList');
    final CollectionReference foodCollection =
        FirebaseFirestore.instance.collection('Category/food/foodList');
    final CollectionReference locationCollection =
        FirebaseFirestore.instance.collection('Category/location/locationList');
    final CollectionReference mathCollection = FirebaseFirestore.instance.collection('Category/math/mathList');
    final CollectionReference numberCollection =
        FirebaseFirestore.instance.collection('Category/number/numberList');
    final CollectionReference otherCollection =
        FirebaseFirestore.instance.collection('Category/other/otherList');
    final CollectionReference pronounCollection =
        FirebaseFirestore.instance.collection('Category/pronoun/pronounList');
    final CollectionReference thingsCollection =
        FirebaseFirestore.instance.collection('Category/things/thingsList');
    final CollectionReference timeCollection = FirebaseFirestore.instance.collection('Category/time/timeList');*/
