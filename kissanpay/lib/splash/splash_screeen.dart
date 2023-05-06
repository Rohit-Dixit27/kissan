import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kissanpay/splash/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashScreen = SplashServices();

  @override

  void initState(){
    super.initState();
    splashScreen.isLogin(context);
  }
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: WillPopScope(
        onWillPop: () => exit(0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/kissan.jpeg',
              height: 109,
              width: 250,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

