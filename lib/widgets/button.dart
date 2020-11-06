import 'package:flutter/material.dart';
import 'custom-text.dart';

class Button extends StatelessWidget {

  final onclick;
  final String text;
  final Color color;
  final bool social;
  final IconData icon;


  const Button({Key key, this.onclick, this.text, this.color: Colors.black, this.social=false, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: onclick,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: color,
        textColor: Colors.white,
        child: social?Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon,color: Colors.black,),
            SizedBox(width: 10,),
            Text(text,style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w900),)
          ],
        ):CustomText(text: text,size: 18,color: Colors.black,),
      ),
    );
  }
}