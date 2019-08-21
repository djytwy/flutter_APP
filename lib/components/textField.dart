import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CusTextField extends StatefulWidget {
  CusTextField({Key key, this.fontSize, this.textCallBack, this.content}) : super(key: key);
  final textCallBack;
  String content;
  double fontSize;

  _CusTextFieldState createState() => _CusTextFieldState();
}

class _CusTextFieldState extends State<CusTextField> {

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
        hintText: '请输入工单描述',
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