import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kissanpay/auth/round_button.dart';
import 'package:kissanpay/auth/session_manager.dart';
import 'package:kissanpay/home/home_screen.dart';
import 'package:kissanpay/utils/utils.dart';


class VerifyCodeScreen extends StatefulWidget {

  final String verificationId;

  const VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {


  bool loading = false;
  final verifycodecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');


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
                        "Enter OTP",
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
                          controller: verifycodecontroller,
                          decoration:  InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color(0xFFe7edeb),
                            hintText: 'Enter 6 digit code',

                          ),

                        ),
                        SizedBox(height: 70,),

                        RoundButton(title: 'Verify', loading: loading, onTap: () async {

                          setState(() {
                            loading = true;
                          });
                          final credential = PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: verifycodecontroller.text.toString()
                          );

                          try{

                            await auth.signInWithCredential(credential).then((value){

                          SessionController().userId = value.user!.uid.toString();


                          ref.child(value.user!.uid.toString()).set({
                          'uid' : value.user!.uid.toString(),
                          'email' : '',
                          'phone' : value.user!.phoneNumber.toString(),
                          'name' : '',
                          'profile' : ''
                          }).then((value){
                          setState(() {
                          loading = false;
                          });

                          }).onError((error, stackTrace){
                          Utils().toastMessage(error.toString());
                          setState(() {
                          loading = false;
                          });
                          });

                          }).onError((error, stackTrace){
                          Utils().toastMessage(error.toString());
                          setState(() {
                          loading = false;
                          });

                          });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

                          }catch(e)
                          {
                            setState(() {
                              loading = false;
                            });

                            Utils().toastMessage(e.toString());

                          }


                        })
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


