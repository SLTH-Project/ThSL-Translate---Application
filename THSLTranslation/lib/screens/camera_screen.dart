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

    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          image: image,
          name: category!.label,
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
        /*Container(
          width: screenSize.width,
          height: screenSize.width,
          child: ClipRRect(
            child: OverflowBox(
              alignment: Alignment.center,
              child:*/
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
              width: screenSize.width,
              height: screenSize.width,
              child: CameraPreview(controller)),
        ),
        /*),
          ),
        ),*/
        Image(
          image: AssetImage('assets/images/frame-camera-front.png'),
        ),
        Image(
          image: AssetImage('assets/images/frame-camera-square.png'),
          height: screenSize.width,
          width: screenSize.width,
        ),
        /*Positioned(
          bottom: 20,
          child: Container(
            width: screenSize.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                capture,
                SizedBox(
                  width: 30,
                ),
                gallery
              ],
            ),
          ),
        ),*/
        capture,
        gallery
      ],
    );

    return Scaffold(
      backgroundColor: Color(0xFFEBEEF5),
      appBar: PreferredSize(
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
                color: Colors.grey,
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
      ),
      body: camera,
    );
  }
}
