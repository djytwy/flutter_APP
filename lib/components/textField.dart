import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustTextField extends StatefulWidget {
  CustTextField({
    Key key, 
    this.fontSize, 
    this.textCallBack, 
    this.setText,
    this.flag=false,
    this.placeHolder
  }) : super(key: key);
  final textCallBack;
  final flag;
  dynamic setText;
  double fontSize;
  String placeHolder;

  _CustTextFieldState createState() => _CustTextFieldState();
}

class _CustTextFieldState extends State<CustTextField> {

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget (CustTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.setText != null && widget.flag) this._controller.text = widget.setText;
  }

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: _controller,
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
        print(text);
        widget.textCallBack(text);
      },
    );
  }
}