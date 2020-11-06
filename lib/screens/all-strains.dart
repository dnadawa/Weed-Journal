import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:weed_journal/screens/details.dart';
import 'package:weed_journal/widgets/custom-text.dart';

class AllStrains extends StatefulWidget {
  @override
  _AllStrainsState createState() => _AllStrainsState();
}

class _AllStrainsState extends State<AllStrains> {

  List<DocumentSnapshot> strains;
  StreamSubscription<QuerySnapshot> subscription;

  getStrains() async {
    await Firebase.initializeApp();
    subscription = FirebaseFirestore.instance.collection('strains').orderBy('name').snapshots().listen((datasnapshot){
      setState(() {
        strains = datasnapshot.docs;
      });
    });
  }

  // getSearchResults(String x) async {
  //   if(x==''){
  //     getStrains();
  //   }
  //   else {
  //     subscription = FirebaseFirestore.instance.collection('strains').where(
  //         'name', isEqualTo: x).snapshots().listen((datasnapshot) {
  //       setState(() {
  //         strains = datasnapshot.docs;
  //       });
  //     });
  //   }
  // }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStrains();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      body: Column(
        children: [
          // Padding(
          //   padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(30),ScreenUtil().setWidth(30),ScreenUtil().setWidth(30),0),
          //   child: TextField(
          //     style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),
          //     decoration: InputDecoration(
          //       hintStyle: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),
          //       hintText: 'Search',
          //       prefixIcon: Icon(Icons.search),
          //       suffixIcon: GestureDetector(onTap: ()=> getStrains(),child: Icon(Icons.clear)),
          //       contentPadding: EdgeInsets.all(15),
          //       filled: true,
          //       fillColor: Theme.of(context).accentColor,
          //       enabledBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(40),
          //           borderSide: BorderSide(width: 0,color: Theme.of(context).accentColor)
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(40),
          //           borderSide: BorderSide(width: 0,color: Theme.of(context).accentColor)
          //       ),
          //     ),
          //     onSubmitted: (x){
          //       print(x);
          //       getSearchResults(x);
          //     },
          //   ),
          // ),
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
                      String symptoms = strains[i]['symptoms'];
                      String effects = strains[i]['effects'];
                      String flavors = strains[i]['flavors'];
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
                                  effects: effects,
                                  flavors: flavors,
                                  symptoms: symptoms,
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
                  ):Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
