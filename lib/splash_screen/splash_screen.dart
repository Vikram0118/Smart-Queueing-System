import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbeacon/globalValues.dart';

import 'login/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //Splash Screen Page Duration
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  //Navigate to next page
  void navigationPage() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)
                              => Login( screenHeight: MediaQuery.of(context).size.height,)));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: BG_Color,
      body: Center(
        child: Transform.scale(
          scale: 1.3,
          child: Container(
            height: 200.0,
            width: 200.0,
            child: Image.asset("assets/QB2.png", fit: BoxFit.cover,),
          ),
        ),
      ),
    );
  }
}
