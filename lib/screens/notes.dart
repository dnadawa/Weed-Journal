import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:weed_journal/widgets/custom-text.dart';

class Notes extends StatefulWidget {
  final String name;
  final String id;
  const Notes({Key key, this.name, this.id}) : super(key: key);
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  List<DocumentSnapshot> notes;
  StreamSubscription<QuerySnapshot> subscription;
  List notesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = FirebaseFirestore.instance.collection('strains').doc(widget.name).collection('notes').where('id', isEqualTo: widget.id).snapshots().listen((datasnapshot){
      setState(() {
        notes = datasnapshot.docs;
        notesList = notes[0]['notes'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Notes',),
      ),
      body: Padding(
        padding:  EdgeInsets.all(ScreenUtil().setHeight(20)),
        child: notes!=null?ListView.builder(
          itemCount: notesList.length,
          itemBuilder: (context,i){
            return Padding(
              padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                  child: CustomText(text: notesList[i],color: Theme.of(context).accentColor,size: ScreenUtil().setSp(30),),
                ),
              ),
            );
          },
        ):Center(child: CustomText(text: 'No Notes',size: ScreenUtil().setSp(40),),),
      ),
    );
  }
}
