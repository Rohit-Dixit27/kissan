import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kissanpay/auth/round_button.dart';
import 'package:kissanpay/auth/verify_code.dart';

import '../utils/utils.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false;
  final phonecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
              Colors.pink.shade900,
              Colors.pink.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36, horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login with phone",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "welcome to kissan pay",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phonecontroller,
                            decoration:  InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xFFe7edeb),
                                hintText: '+91 7678222276',
                                prefixIcon: Icon(Icons.phone)
                            ),

                          ),
                          SizedBox(height: 10,),

                    RoundButton(title: 'Login', loading: loading, onTap: () {

                      setState(() {
                        loading = true;
                      });
                      auth.verifyPhoneNumber(
                          phoneNumber: phonecontroller.text,
                          verificationCompleted: (_){
                            setState(() {
                              loading = false;
                            });
                          },
                          verificationFailed: (e){
                            setState(() {
                              loading = false;
                            });
                            Utils().toastMessage(e.toString());
                          },
                          codeSent: (String verificationId, int? token) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId)));

                            setState(() {
                              loading = false;
                            });
                          },
                          codeAutoRetrievalTimeout: (e){
                            Utils().toastMessage(e.toString());
                            setState(() {
                              loading = false;
                            });
                          });
                    }),
                  ],
                      ),
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


