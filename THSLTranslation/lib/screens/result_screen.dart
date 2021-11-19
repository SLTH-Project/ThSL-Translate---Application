// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:image/image.dart' as imgg;

class ResultPage extends StatefulWidget {
  //const ResultPage({Key? key, required this.imagePath}) : super(key: key);
  const ResultPage({Key? key, required this.image, required this.name})
      : super(key: key);

  //final String imagePath;
  final File image;
  final String name;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Image.file(
              //File(widget.imagePath),
              widget.image,
              fit: BoxFit.cover,
            ),
          ),
          Text(widget.name)
        ],
      ),

      /*Image.file(
          File(widget.imagePath),
          scale: 0.61,
        )*/
      /*AspectRatio(
          aspectRatio: 487 / 451,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.topCenter,
                    image: AssetImage(widget.imagePath))),
          ),
        )*/
    );
  }
}
