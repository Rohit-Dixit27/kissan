
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kissanpay/auth/login_screen.dart';
import 'package:kissanpay/auth/session_manager.dart';

import '../home/home_screen.dart';



class SplashServices {

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if(user !=null ){

      SessionController().userId = user.uid.toString();

      Timer(const Duration(seconds: 3), () => Navigator.push(context,
      MaterialPageRoute(builder: (context) => HomeScreen()))
    );
    }else{
      Timer(const Duration(seconds: 3), () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginScreen()))
      );


          }
  }

}