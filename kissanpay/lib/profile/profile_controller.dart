
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:kissanpay/auth/session_manager.dart';

import '../utils/utils.dart';

class ProfileController with ChangeNotifier{

  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

 final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future pickgalleryimage(BuildContext context) async
  {
    final pickedfile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if(pickedfile!= null){
      _image = XFile(pickedfile.path);
      uploadimage(context);
      notifyListeners();
    }
  }


 Future pickcameraimage(BuildContext context) async
 {
   final pickedfile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

   if(pickedfile!= null){
     _image = XFile(pickedfile.path);
     uploadimage(context);
     notifyListeners();
   }
  }


  void pickImage(context){

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: (){
                      pickcameraimage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.camera, color: Colors.black,),
                    title: Text("Camera"),
                  ),
                  ListTile(
                    onTap: (){
                      pickgalleryimage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.image, color: Colors.black,),
                    title: Text("Gallery"),
                  )

                ],
              ),
            ),
          );

        });

  }

  void uploadimage(BuildContext context) async {

    setLoading(true);

    firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref('/profileimage'+SessionController().userId.toString());
    firebase_storage.UploadTask uploadTask = storageRef.putFile(File(image!.path).absolute);

    await Future.value(uploadTask);
    final newUrl = await storageRef.getDownloadURL();

    ref.child(SessionController().userId.toString()).update({
      "profile" : newUrl.toString()
    }).then((value){
      Utils().toastMessage("Profile Updated");
      setLoading(false);
      _image = null;
    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setLoading(false);
    });

  }


  Future<void> showUserNameDialogAlert(BuildContext context, String name){
    namecontroller.text = name;
    return showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: Text("update name"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: namecontroller,
                keyboardType: TextInputType.text,
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("cancel")),
          TextButton(onPressed: (){

            ref.child(SessionController().userId.toString()).update({
              "name" : namecontroller.text.toString()
            }).then((value){
              namecontroller.clear();
            });
            Navigator.pop(context);
          }, child: Text("ok"))
        ],
      );
        });
  }

  Future<void> showUserPhoneDialogAlert(BuildContext context, String phone){
    phonecontroller.text = phone;
    return showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("update phone number"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phonecontroller,
                    keyboardType: TextInputType.phone,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("cancel")),
              TextButton(onPressed: (){

                ref.child(SessionController().userId.toString()).update({
                  "phone" : phonecontroller.text.toString()
                }).then((value){
                  phonecontroller.clear();
                });
                Navigator.pop(context);
              }, child: Text("ok"))
            ],
          );
        });
  }
}