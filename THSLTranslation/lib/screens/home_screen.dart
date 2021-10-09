// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    File _image;
    final imagePicker = ImagePicker();
    Future getImage() async {
      final image = await imagePicker.getImage(source: ImageSource.camera);
      setState(() {
        _image = File(image.path);
      });
    }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text("No inage selected") : Image.file(_image),
            FloatingActionButton(
              onPressed: getImage,
              backgroundColor: Colors.blue,
              child: Icon(Icons.camera_alt),
            )
          ],
        ),
      ),
    );
  }
}
