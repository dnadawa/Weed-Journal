import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:weed_journal/screens/details.dart';
import 'package:weed_journal/widgets/custom-text.dart';

class SavedStrains extends StatefulWidget {
  @override
  _SavedStrainsState createState() => _SavedStrainsState();
}

class _SavedStrainsState extends State<SavedStrains> {

  List<DocumentSnapshot> strains;
  StreamSubscription<QuerySnapshot> subscription;
  String deviceId;

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

  getStrains() async {
    await Firebase.initializeApp();
    await getDeviceID();
    subscription = FirebaseFirestore.instance.collection('strains').where('saved', arrayContains: deviceId).orderBy('name').snapshots().listen((datasnapshot){
      setState(() {
        strains = datasnapshot.docs;
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStrains();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:  EdgeInsets.all(ScreenUtil().setWidth(30)),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setHeight(25)),
                  child: strains!=null?ListView.builder(
                    itemCount: strains.length,
                    itemBuilder: (context,i){
                      String name = strains[i]['name'];
                      String image = strains[i]['image'];
                      String condition = strains[i]['conditions'];
                      String genetics = strains[i]['genetics'];
                      String info = strains[i]['info'];
                      List saved = strains[i]['saved'];

                      return Padding(
                        padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            onTap: (){
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => Details(
                                  name: name,
                                  image: image,
                                  conditions: condition,
                                  genetics: genetics,
                                  info: info,
                                  saved: saved,
                                )),
                              );
                            },
                            title: CustomText(text: name,),
                            trailing: Icon(Icons.arrow_forward,color: Colors.white,),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              backgroundImage: NetworkImage(image),
                            ),
                          ),
                        ),
                      );
                    },
                  ):Center(child: CircularProgressIndicator(),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
