import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 参数定义：context: 传入的上下文, backHome:传入的函数

void ShowVoiceRecogize(BuildContext context, backHome) async {
  // 备用变量
  var k = 'test';
  await showDialog(
    context: context,
    builder: (BuildContext context){
      return SimpleDialog(
        children: <Widget>[
          Container(
            color: Colors.pinkAccent,
            height: ScreenUtil.getInstance().setHeight(1344),
            width: ScreenUtil.getInstance().setWidth(750),
          )
        ],
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.all(0),
      );
    }
  ).then((val) {
    print(k);
    backHome();
  });
}
     