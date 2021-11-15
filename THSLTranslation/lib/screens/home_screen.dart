//import 'dart:html';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:thsltranslation/screens/result_screen.dart';

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

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final CollectionReference categoryPicCollection =
        FirebaseFirestore.instance.collection('CategoryPic');
    final CollectionReference HowToCollection =
        FirebaseFirestore.instance.collection('HowTo');
    final CollectionReference animalCollection =
        FirebaseFirestore.instance.collection('Category/animal/animalList');
    final CollectionReference actionCollection =
        FirebaseFirestore.instance.collection('Category/action/actionList');
    bool yes = false;
    print('yes = ');
    print(yes);

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
                  stream: HowToCollection.snapshots(),
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
            stream: categoryPicCollection.snapshots(),
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
                        yes = true;
                        print('yes = ');
                        print(yes);
                        return;
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

    (context as Element).reassemble();

    final rowVocab = Container(
        height: 180,
        color: Colors.white,
        child: StreamBuilder(
            stream: animalCollection.snapshots(),
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
                        return;
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
                    final image = await controller.takePicture();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          imagePath: image.path,
                        ),
                      ),
                    );
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
        capture,
        Image(
          image: AssetImage('assets/images/frame-camera-front.png'),
        ),
        Image(
          image: AssetImage('assets/images/frame-camera-square.png'),
          height: screenSize.width,
          width: screenSize.width,
        ),
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
                  Text(
                    'คลังภาษามือไทย 100 คำ',
                    style: TextStyle(
                      fontFamily: 'Anakotmai',
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  yes ? rowVocab : rowCatagory,
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
                ])));
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