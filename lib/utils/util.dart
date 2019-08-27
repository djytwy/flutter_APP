import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/loading.dart';

const white_color = Color.fromRGBO(255, 255, 255, 1);// 白色
const white_name_color = Color.fromRGBO(224, 224, 224, 1);// 白色名称颜色
const module_background_color = Color.fromARGB(100, 12, 33, 53);//模块背景色

void showLoading(context) async{
  await Future.delayed(Duration(milliseconds: 50));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return new NetLoadingDialog(
          outsideDismiss: false,
        );
      }
    );
}
void hideLoading(context) async{
  await Future.delayed(Duration(milliseconds: 50));
  Navigator.pop(context);
}






// 显示totast 全部弹出
void showTotast(String msg){
  if (msg != null) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(150, 150, 150, 0.4),
      textColor: Colors.white,
      fontSize: 12
    );
  }
}
// 隐藏全局弹出
void hideTotast(){
  Fluttertoast.cancel();
}
// 设置宽高，字体大小， margin ,padding 间距 的自适应方法
class SelfAdapt {
  SelfAdapt.init(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667, allowFontScaling: true)..init(context);
  }
  setWidth(double n){
    return ScreenUtil().setWidth(n.toDouble());
  }
  setHeight(double n){
    return ScreenUtil().setHeight(n.toDouble());
  }
  setFontSize(double n){
    return ScreenUtil(allowFontScaling: true).setSp(n.toDouble());
  }
  setMargin(double n){
    return EdgeInsets.only(left: setWidth(n), right: setWidth(n), top: setHeight(n), bottom: setHeight(n));
  }
}