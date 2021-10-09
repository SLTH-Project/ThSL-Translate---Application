// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
      expandedValue:
          'ตั้งกล้องให้ขนาดของลำตัวตั้งแต่เหนือศีรษะจนถึงเอวอยู่พอดีกรอบ',
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
          body: ListTile(
            title: Text(item.expandedValue,
                style: TextStyle(
                  fontFamily: 'Anakotmai',
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
            //trailing: const Icon(Icons.delete),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xF7F7F7FF),
      appBar: AppBar(
        title: Text('THSL Translate',
            style: TextStyle(
              fontFamily: 'Anakotmai',
              color: Color(0xFF2B2B2B),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(children: [
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
          _buildPanel(),
          SizedBox(
            height: 20,
          )
        ])),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.camera_alt),
      ),
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