import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kissanpay/auth/login_screen.dart';
import 'package:kissanpay/auth/round_button.dart';

import '../home/home_screen.dart';
import 'session_manager.dart';
import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');


  void signup()
  {
    setState(() {
      loading = true;
    });
    auth.createUserWithEmailAndPassword(email: emailcontroller.text.toString(),
        password: passwordcontroller.text.toString()).then((value){

      SessionController().userId = value.user!.uid.toString();


      ref.child(value.user!.uid.toString()).set({
            'uid' : value.user!.uid.toString(),
            'email' : value.user!.email.toString(),
            'phone' : '',
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

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });

    });
  }
  @override
  void dispose(){
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "SignUp",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46,
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
                          fontSize: 20,
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
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailcontroller,
                                decoration:  InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFe7edeb),

                                    hintText: 'Email',

                                    prefixIcon: Icon(Icons.email)
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter email';
                                  }
                                  return null;
                                },

                              ),
                              const SizedBox(height: 20,),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passwordcontroller,
                                obscureText: true,
                                decoration:  InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFe7edeb),
                                    hintText: 'Password',
                                    prefixIcon: Icon(Icons.lock_outline)
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter password';
                                  }
                                  return null;
                                },

                              ),

                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RoundButton(
                          title: 'Signup',
                          loading: loading,
                          onTap: (){
                            if(_formkey.currentState!.validate()){

                              signup();
                            }
                          },
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account"),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen())
                              );

                            }, child: Text("Login"))
                          ],
                        )
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


