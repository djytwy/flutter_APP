import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../pages/Login.dart';

const white_color = Color.fromRGBO(255, 255, 255, 1);// 白色
const white_name_color = Color.fromRGBO(224, 224, 224, 1);// 白色名称颜色
const module_background_color = Color.fromARGB(100, 12, 33, 53);//模块背景色
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
  List list = json.decode(str);
  Map data = {
    'admin': list.any((element)=>(element == 50)), // 管理员权限
    'repair': list.any((element)=>(element == 51)),// 报修权限
    'keepInRepair': list.any((element)=>(element == 52)), // 维修权限
    'addShiftDuty': list.any((element)=>(element == 53)),  // 换班申请
    'shiftDutyShow': list.any((element)=>(element == 54)),  //排班表展示
    'shiftDutyManage': list.any((element)=>(element == 48)),  // 排班管理
  };
  // Map data = {
  //   'admin': true, // 管理员权限
  //   'repair': true,// 报修权限
  //   'keepInRepair': true, // 维修权限
  //   'addShiftDuty': true, // 换班申请
  //   'shiftDutyShow': true, //排班表展示
  //   'shiftDutyManage': true, // 排班管理
  // };
  return data;
}

// 获取初始化当前日期字符串
String getCurrentDay(){
  var item = new DateTime.now();
  String year = item.year.toString();
  String month = item.month >= 10 ? item.month.toString() : '0'+item.month.toString();
  String day = item.day >= 10 ? item.day.toString(): '0'+item.day.toString();
  String str = year +'-'+ month +'-'+day;
  return str;
}

// 弹出提示
void showAlertDialog(BuildContext context,{String title = '提示',String text = '', Function onOk, Function onCancel}) {
  var _adapt = SelfAdapt.init(context);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Container(
                width: _adapt.setWidth(270),
                decoration: BoxDecoration(
                  color:Color.fromRGBO(0, 13, 27, 1),
                  border: Border.all(width: _adapt.setHeight(1), color: Color.fromRGBO(58, 132, 238, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  
                ),
                child: Column(
                  children: <Widget>[
                      Container(
                        height: _adapt.setHeight(100),
                        width: double.infinity,
                        padding: EdgeInsets.only(top: _adapt.setHeight(20)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                           gradient: LinearGradient(colors: [Color.fromRGBO(0, 17, 27, 1), Color.fromRGBO(20, 47, 83, 1), Color.fromRGBO(20, 47, 83, 1), Color.fromRGBO(0, 17, 27, 1)], begin: FractionalOffset(1, 1), end: FractionalOffset(0, 1))
                          // color: Color.fromRGBO(25, 51, 87, 1)
                          // image: new DecorationImage(
                          //   alignment: Alignment.topLeft,
                          //   image: new AssetImage('assets/images/dialogBackg.png'), 
                          //   fit: BoxFit.fill 
                          // ),
                        ),
                        child: Column(
                          children: <Widget>[
                              // Container(
                                // child: 
                                Text( title, style: TextStyle( color: Colors.white, fontSize: _adapt.setFontSize(16), fontWeight: FontWeight.bold)),
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: _adapt.setHeight(12)),
                                child: Text( text, style: TextStyle( color: Colors.white, fontSize: _adapt.setFontSize(12), fontWeight: FontWeight.bold)),
                              )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: _adapt.setHeight(1),
                        color: Color.fromRGBO(58, 132, 238, 1),
                      ),
                      Container(
                        height: _adapt.setHeight(43),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                  onTap: (){
                                    if(onCancel != null){
                                        onCancel();
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text('取消', style: TextStyle(color: white_name_color, fontSize: _adapt.setFontSize(16))),
                                  ),
                              )
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  if (onOk != null) {
                                    onOk();
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text('确认', style: TextStyle(color: Colors.white, fontSize: _adapt.setFontSize(16))),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(58, 132, 238, 1),
                                      borderRadius: BorderRadius.only( bottomRight: Radius.circular(3))
                                    ),
                                ),
                              )
                            )
                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          );
      }
    );
}
// 上下文
var CTX;
// 退出登陆
void signOut() async{
  if(CTX != null){
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('menus');
      prefs.remove('userName');
      prefs.remove('postName');
      prefs.remove('userId');
      prefs.remove('departmentName');
      prefs.remove('phoneNum');
      Navigator.pushReplacement(CTX.currentState.overlay.context, MaterialPageRoute(
          builder: (context) => new Test()
      ));
      // CTX.currentState.pushReplacement();
  }
}




