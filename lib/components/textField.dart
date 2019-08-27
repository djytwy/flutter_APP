import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustTextField extends StatefulWidget {
  CustTextField({
    Key key, 
    this.fontSize, 
    this.textCallBack, 
    this.placeHolder
  }) : super(key: key);
  final textCallBack;
  double fontSize;
  String placeHolder;

  _CustTextFieldState createState() => _CustTextFieldState();
}

class _CustTextFieldState extends State<CustTextField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _controller = TextEditingController();

    return TextField(
      // controller: _controller,
      decoration: InputDecoration(
        focusColor: Colors.white,
        hoverColor: Colors.white,
        hintText: widget.placeHolder,
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none   // 禁止边框
      ),
      maxLines: 3,
      style: TextStyle(fontSize: widget.fontSize,color: Colors.white),
      // 点击回车时的逻辑
      // onSubmitted: (text) {  
      //   widget.textCallBack(text);
      // },
      onChanged: (text) {
        widget.textCallBack(text);
        // _controller.text = text;
      },
    );
  }
}