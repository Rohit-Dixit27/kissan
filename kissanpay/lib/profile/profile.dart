import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kissanpay/auth/login_screen.dart';
import 'package:kissanpay/auth/round_button.dart';
import 'package:kissanpay/auth/session_manager.dart';
import 'package:kissanpay/profile/profile_controller.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final ref = FirebaseDatabase.instance.ref('User');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider(
         create: (_) => ProfileController(),
        child: Consumer<ProfileController>(
          builder: (context, provider, child){
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder(
                  stream: ref.child(SessionController().userId.toString()).onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black12,
                                            width: 2
                                        )


                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: provider.image == null ? map['profile'].toString() == "" ? const Icon(Icons.person):
                                      Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(map['profile'].toString()),
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(child: CircularProgressIndicator());
                                        },
                                        errorBuilder: (context, object, stack) {
                                          return Container(
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ):
                                          Stack(
                                            children: [
                                              Image.file(
                                                File(provider.image!.path).absolute
                                              ),
                                              Center(child: CircularProgressIndicator())
                                            ],
                                          )
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  provider.pickImage(context);
                                },
                                child: CircleAvatar(
                                  radius: 14,
                                  child: Icon(Icons.add, size: 15, color: Colors.white,),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              provider.showUserNameDialogAlert(context, map['name']);
                            },
                            child: RowforData(
                              title: "name",
                              value: map["name"] == ""?
                              map["name"] = "abc":
                              map["name"],
                              icondata: Icons.person,
                            ),
                          ),
                          RowforData(
                              title: "Email",
                              icondata: Icons.email,
                              value: map["email"]),
                          GestureDetector(
                            onTap: (){
                              provider.showUserPhoneDialogAlert(context, map['phone']);
                            },
                            child: RowforData(
                              title: "Phone",
                              value: map["phone"] == ""?
                              map["phone"] = "+91 xxx-xxx-xxxx":
                              map["phone"],
                              icondata: Icons.phone,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          RoundButton(title: "Logout", onTap: (){
                            FirebaseAuth auth  = FirebaseAuth.instance;

                            auth.signOut().then((value){
                              SessionController().userId = '';
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

                            });
                          })
                        ],
                      );
                    } else {
                      return Center(child: Text("Something went wrong"));
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RowforData extends StatelessWidget {
  final String title, value;
  final IconData icondata;
  const RowforData(
      {Key? key,
      required this.title,
      required this.icondata,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(icondata),
          trailing: Text(value),
        ),
        Divider(color: Colors.black12,)
      ],
    );
  }
}
