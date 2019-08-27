import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextLable extends StatelessWidget {
  TextLable({
    Key key,
    this.bgcolor,
    this.text,
    this.broderColor,
    this.align='left'
    }) : super(key: key);
  
  final bgcolor;
  final broderColor;
  final text;
  final align;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align == 'left' ? Alignment.centerLeft: Alignment.centerRight,
      child:  Container(
        margin: EdgeInsets.all(5.0),
        width: ScreenUtil.getInstance().setWidth(192),
        height: ScreenUtil.getInstance().setHeight(60),
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: broderColor,
            width: 0.2
          )
        ),
        child: Center(
          child: Text(text, style:TextStyle(color: Colors.white))
        ),
      ),
    );
  }
}