import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:weed_journal/widgets/button.dart';
import 'package:weed_journal/widgets/custom-text.dart';
import 'package:weed_journal/widgets/inputfield.dart';
import 'package:weed_journal/widgets/toast.dart';


class AddStrain extends StatefulWidget {
  @override
  _AddStrainState createState() => _AddStrainState();
}

class _AddStrainState extends State<AddStrain> {

  File image;
  TextEditingController name = TextEditingController();
  TextEditingController information = TextEditingController();
  TextEditingController genetics = TextEditingController();
  TextEditingController conditions = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
              child: CustomText(text: 'Upload Strain Picture',size: ScreenUtil().setSp(35),),
            ),
            GestureDetector(
              onTap: () async {
                image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);
                setState(() {});
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: ScreenUtil().setHeight(100),
                child: image==null?Icon(Icons.cloud_upload,color: Colors.black,size: ScreenUtil().setHeight(100),):null,
                backgroundImage: image!=null?FileImage(image):null,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
              child: InputField(hint: 'Strain Name',controller: name,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
              child: InputField(hint: 'Strain Information',controller: information,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
              child: InputField(hint: 'Genetics',controller: genetics,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
              child: InputField(hint: 'Conditions',controller: conditions,),
            ),
            Padding(
              padding:  EdgeInsets.all(ScreenUtil().setWidth(90)),
              child: Button(color: Theme.of(context).accentColor,text: 'Add',onclick: () async {
                if(image!=null){
                  try{
                    await Firebase.initializeApp();
                    Reference ref = FirebaseStorage.instance.ref().child("${name.text}.jpg");
                    ToastBar(text: 'Please wait...',color: Colors.orangeAccent).show();
                    await ref.putFile(image);
                    String downloadURL = await ref.getDownloadURL();
                    print(downloadURL);

                    await FirebaseFirestore.instance.collection('strains').doc(name.text).set({
                      'name': name.text,
                      'info': information.text,
                      'genetics': genetics.text,
                      'conditions': conditions.text,
                      'image': downloadURL,
                      'saved': []
                    });

                    name.clear();
                    information.clear();
                    genetics.clear();
                    conditions.clear();
                    image = null;
                    setState(() {});

                    ToastBar(text: 'Added Successfully!',color: Colors.green).show();
                  }
                  catch(e){
                    ToastBar(text: e.toString(),color: Colors.red).show();
                  }
                }
                else{
                  ToastBar(text: 'Image not selected!',color: Colors.red).show();
                }

              },),
            ),
          ],
        ),
      ),
    );
  }
}
