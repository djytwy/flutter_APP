import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
void showTotast([String msg, String position = 'center', int second = 1]){
  Map data = {
    'top': ToastGravity.TOP,
    'center': ToastGravity.CENTER,
    'bottom' : ToastGravity.BOTTOM
  };
  if (msg != null) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: data[position],
      timeInSecForIos: second,
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
// 获取本地存储
Future getLocalStorage(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userName = await prefs.getString(name);
  return userName;
}

// 获取权限
// 50 -- 管理员， 51 -- 报修，  52 -- 维修， 53 -- 换班申请， 54 -- 排班表展示
Future getAllAuths() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String  str = await prefs.getString('authMenus'); 
  List obj = json.decode(str);
  Map data = {
    'admin': obj.any((element)=>(element == 50)), // 管理员权限
    'repair': obj.any((element)=>(element == 51)),// 报修权限
    'keepInRepair': obj.any((element)=>(element == 52)), // 维修权限
  };
  // Map data = {
  //   'admin': true, // 管理员权限
  //   'repair': true,// 报修权限
  //   'keepInRepair': true, // 维修权限
  // };
  return data;
}




