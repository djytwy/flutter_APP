import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickButton extends StatelessWidget {
  QuickButton({Key key, this.buttonText ,this.clickCallBack}) : super(key: key);
  final clickCallBack ;
  String buttonText;
  double fontSize = ScreenUtil.getInstance().setSp(20);   // 默认字体大小

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Color.fromARGB(100, 89, 155, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: _clickCallBack,
      child: Text(buttonText, style: TextStyle(fontSize: fontSize)),
    );
  }

  void _clickCallBack() {
    clickCallBack(buttonText);
  }
}