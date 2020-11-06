import 'package:flutter/material.dart';
import 'package:weed_journal/screens/home.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff004D40),
        accentColor: Color(0xffEFF48E),
        scaffoldBackgroundColor: Color(0xff3E978B),
      ),
      home: Home(),
    );
  }
}
