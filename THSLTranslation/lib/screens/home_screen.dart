// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'package:camera/camera.dart';
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
      expandedValue: 'สวัสดีจ้าาาาาาาาา',
    );
  });
}

// ignore: use_key_in_widget_constructors
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

  Widget _buildPanel() {
    return ExpansionPanelList(
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
            height: 134,
            color: Colors.blue,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 3, //จำนวนหมวด
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    return;
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      width: 259,
                      height: 134,
                      child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Positioned(
                              top: 15,
                              child: Image(
                                image: AssetImage('assets/images/step1.png'),
                                height: 63,
                                width: 63,
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Text(''' ตั้งกล้องให้ขนาดของลำตัวตั้งแต่
เหนือศีรษะจนถึงเอวอยู่พอดีกรอบ'''),
                            )
                          ])),
                );
              },
            ),
          )
          /*ListTile(
            title: Text(item.expandedValue,
                style: TextStyle(
                  fontFamily: 'Anakotmai',
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
            //trailing: const Icon(Icons.delete), //icon ท้าย
          )*/
          ,
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final rowCatagory = Container(
      height: 115,
      color: Colors.blue,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5, //จำนวนหมวด
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              return;
            },
            child: Container(
                margin: EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.red),
                width: 98,
                height: 115,
                child: Stack(alignment: Alignment.topCenter, children: <Widget>[
                  Positioned(
                    bottom: 0,
                    child: Container(
                        height: 60,
                        width: 98,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(1),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('ชื่อหมวด'),
                                  Text('ชื่อหมวด2')
                                ]))),
                  )
                ])),
          );
        },
      ),
    );

    final colCatagory = Container(
      height: 240,
      color: Colors.orange,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            color: Colors.red,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                rowCatagory,
              ],
            ),
          ),
        ],
      ),
    );

    final camera = Container(
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
    );

    final capture = Positioned(
        top: screenSize.width - 60,
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
                  color: Colors.red,
                  size: 50,
                ))));

    final bottomSwipeUp = SizedBox.expand(
      child: DraggableScrollableSheet(
          initialChildSize: 0.1,
          minChildSize: 0.1,
          maxChildSize: 0.5,
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
                  rowCatagory,
                  SizedBox(
                    height: 10,
                  ),
                  rowCatagory
                ],
              ),
            );
          }),
    );

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
                //capture,
                _buildPanel(),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          capture,
          bottomSwipeUp
        ]),
      ),
      /*floatingActionButton: Container(
        height: 50,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () async {},
            icon: Image(
              image: AssetImage(
                'assets/images/logoyellow.png',
              ),
              height: 40,
            ),
            label: Text('คลังภาษามือไทย'),
            backgroundColor: Colors.indigo,
          ),
        ),
      ),*/
    );
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
