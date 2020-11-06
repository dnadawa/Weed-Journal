import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:weed_journal/screens/notes.dart';
import 'package:weed_journal/widgets/button.dart';
import 'package:weed_journal/widgets/custom-text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weed_journal/widgets/toast.dart';
class Details extends StatefulWidget {
  final String name;
  final String image;
  final String info;
  final String genetics;
  final String conditions;
  final List saved;

  const Details({Key key, this.name, this.image, this.info, this.genetics, this.conditions, this.saved}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isSaved = false;
  List saved;
  String deviceId;
  TextEditingController note = TextEditingController();

  getDeviceID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
    }
    else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    print(deviceId);
  }

  checkStatus() async {
    await getDeviceID();
    if(saved.contains(deviceId)){
      setState(() {
        isSaved = true;
      });
    }
    else{
      isSaved = false;
    }
  }

  popUpCard(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: CustomText(text: 'Add a note',align: TextAlign.center,color: Colors.black,),
          content: Container(
            height: ScreenUtil().setHeight(280),
            child: Column(
              children: [
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter Note',
                    enabledBorder:UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5),
                    ),
                  ),
                  controller: note,
                ),
                Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setHeight(40)),
                  child: Button(text: 'Add',color: Theme.of(context).accentColor,onclick: () async {
                    ToastBar(text: 'Please wait...',color: Colors.orange).show();
                    var sub = await FirebaseFirestore.instance.collection('strains').doc(widget.name).collection('notes').where('id', isEqualTo: deviceId).get();
                    var noteList = sub.docs;
                    if(noteList.isNotEmpty){
                      List notes = noteList[0]['notes'];
                      notes.add(note.text);
                      await FirebaseFirestore.instance.collection('strains').doc(widget.name).collection('notes').doc(deviceId).update({
                        'notes': notes
                      });
                      ToastBar(text: 'Note Added!',color: Colors.green).show();
                    }
                    else{
                      List notes = [];
                      notes.add(note.text);
                      await FirebaseFirestore.instance.collection('strains').doc(widget.name).collection('notes').doc(deviceId).set({
                        'notes': notes,
                        'id': deviceId
                      });
                      ToastBar(text: 'Note Added!',color: Colors.green).show();
                    }
                    note.clear();
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saved = widget.saved;
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Details',),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notes),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Notes(name: widget.name,id: deviceId,)),
          );
        },
      ),
      body: Padding(
        padding:  EdgeInsets.all(ScreenUtil().setHeight(30)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    CircleAvatar(
                      radius: ScreenUtil().setHeight(110),
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(text: widget.name,size: ScreenUtil().setSp(45),),
                        SizedBox(height: ScreenUtil().setHeight(10),),
                        Padding(
                          padding:  EdgeInsets.only(left: ScreenUtil().setHeight(30)),
                          child: Button(text: 'Add note',onclick: ()=>popUpCard(context),color: Theme.of(context).accentColor,),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: ScreenUtil().setHeight(30)),
                          child: Button(text: !isSaved?'Save':'Unsave',onclick: () async {
                            await getDeviceID();
                            if(!isSaved){
                              saved.add(deviceId);
                              await FirebaseFirestore.instance.collection('strains').doc(widget.name).update({
                                'saved': saved
                              });
                              setState(() {
                                isSaved = true;
                              });
                            }
                            else{
                              saved.remove(deviceId);
                              await FirebaseFirestore.instance.collection('strains').doc(widget.name).update({
                                'saved': saved
                              });
                              setState(() {
                                isSaved = false;
                              });
                            }
                            },
                            color: Theme.of(context).accentColor,),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(60),),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(35)),
                child: CustomText(text: 'Strain Information :',size: ScreenUtil().setSp(35),),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                  child: CustomText(text: widget.info,color: Theme.of(context).accentColor,size: ScreenUtil().setSp(30),),
                ),
              ),


              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(35)),
                child: CustomText(text: 'Genetics :',size: ScreenUtil().setSp(35),),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                  child: CustomText(text: widget.genetics,color: Theme.of(context).accentColor,size: ScreenUtil().setSp(30),),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(35)),
                child: CustomText(text: 'Conditions :',size: ScreenUtil().setSp(35),),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                  child: CustomText(text: widget.conditions,color: Theme.of(context).accentColor,size: ScreenUtil().setSp(30),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
