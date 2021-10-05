import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Image.network(
            'https://www.google.co.th/url?sa=i&url=https%3A%2F%2Fwww.pikpng.com%2Ftranspng%2FhoJhiww%2F&psig=AOvVaw0vp5qTrGNWWpoeDDF1INjP&ust=1633482760744000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCLjuz9mLsvMCFQAAAAAdAAAAABAD'));
  }
}
