import '../models/constants.dart';
import 'homepage.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
  
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5), 
      () {
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        //color: AppConstants.themeColorShade3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 249, 112, 103),
              Color.fromARGB(255, 251, 102, 104),
              Color.fromARGB(255, 253, 82, 106),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 0.5, 1.0]
          ),
        ),
        child: Image.asset(AppConstants.imagesFolder + 'splash_image.gif'),
      ),
    );
  }
  
}