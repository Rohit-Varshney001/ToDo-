import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/database%20helper/check_user.dart';
import 'package:todo_app/slider/slider_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckUser()));
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),

    );
  }
}
