import 'package:flutter/material.dart';
import '../../../utils/util.dart';
import '../../ModifyPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_tims_hotel/pages/barcodeScan/barcodeScan.dart';
import 'package:flutter/foundation.dart';
import '../../../config/serviceUrl.dart';
import '../../../config/config.dart';

Widget header (_userName) {
  return DrawerHeader(
    padding: EdgeInsets.zero, /* padding置为0 */
    child: new Stack(children: <Widget>[ /* 用stack来放背景图片 */
      // new Image.asset(
      //   'assets/images/background.png', fit: BoxFit.fill, width: double.infinity,),
      new Align(/* 先放置对齐 */
        alignment: FractionalOffset.center,
        child: Container(
          // height: 100.0,
          width: 100.0,
          margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min, /* 宽度只用包住子组件即可 */
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                child: Center(
                  child: new CircleAvatar(
                    backgroundImage: AssetImage('assets/images/LOGO.png'),
                    radius: 35.0,),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Center(
                  child: new Text(
                    _userName, style: new TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white
                    )
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}

Widget drawerPage(
  String projectName,
  String userName,
  SelfAdapt _adapt,
  String postName,
  dynamic postNum,
  String departmentName,
  BuildContext context) {
  return Container(
    decoration: new BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/background.png"),
        fit: BoxFit.cover
      )
    ),
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        header(userName),  // 上面是自定义的header
        ListTile(
          title: Container(
            margin: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10),top: _adapt.setHeight(20),bottom: _adapt.setHeight(10)),
            color: Color.fromRGBO(4, 38, 83, 0.35),
            height: _adapt.setHeight(45),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10)),
                  child: new Text('部门',style: TextStyle(color: Color(0xFF999999),fontSize: _adapt.setFontSize(16))),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10)),
                  child: new Text(departmentName,style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
                )
              ],
            )
          ),
          enabled: false,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Container(
            margin: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10),bottom: _adapt.setHeight(10)),
            color: Color.fromRGBO(4, 38, 83, 0.35),
            height: _adapt.setHeight(45),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10)),
                  child: new Text('电话',style: TextStyle(color: Color(0xFF999999),fontSize: _adapt.setFontSize(16))),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10)),
                  child: new Text(postNum,style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
                )
              ],
            )
          ),
          enabled: false,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Container(
            margin: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10),bottom: _adapt.setHeight(10)),
            color: Color.fromRGBO(4, 38, 83, 0.35),
            height: _adapt.setHeight(45),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10)),
                  child: new Text('职位',style: TextStyle(color: Color(0xFF999999),fontSize: _adapt.setFontSize(16))),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10)),
                  child: new Text(postName,style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
                )
              ],
            )
          ),
          enabled: false,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => new ModifyPassword()
              ));
            },
            child: Container(
              margin: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10),bottom: _adapt.setHeight(10)),
              color: Color.fromRGBO(4, 38, 83, 0.35),
              height: _adapt.setHeight(45),
              child: Row(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10)),
                    child: new Text('修改密码',style: TextStyle(color: Color(0xFF999999),fontSize: _adapt.setFontSize(16))),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: _adapt.setHeight(100)),
                    child: Icon(Icons.keyboard_arrow_right,color: Color(0xFF999999)),
                  )
                ],
              )
            ),
          )
        ),
        ListTile(
          title: GestureDetector(
            onTap: signOut,
            child: Container(
              margin: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10),top: _adapt.setHeight(90)),
              color: Color.fromRGBO(4, 38, 83, 0.35),
              height: _adapt.setHeight(45),
              child: new Center(
                child: new Text('退出登录',style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
              )
            ),
          )
        ),
        // 扫描二维码
        ListTile(
          title: GestureDetector(
            onTap: () {_unbind(context);},
            child: Container(
              margin: EdgeInsets.only(left: _adapt.setHeight(10),right: _adapt.setHeight(10),top: _adapt.setHeight(10)),
              color: Color.fromRGBO(4, 38, 83, 0.35),
              height: _adapt.setHeight(45),
              child: Center(
                child: Text('解除绑定',style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
              )
            ),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: _adapt.setHeight(20)),
          child: Text(projectName, style:TextStyle(color:Colors.white54)),
        ),
        Container(
          margin: EdgeInsets.only(top: _adapt.setHeight(5)),
          child: kReleaseMode ? Text('正式版本号: ${_genVersion()}',style:TextStyle(color:Colors.white54)) : Text('debug 版本号: ${_genVersion()}',style:TextStyle(color:Colors.white54)),
        )
      ],
    ),
  );
}

// 生成版本号
String _genVersion() {
//  DateTime now = DateTime.now();
//  dynamic version = (now.day + 10).toString();
//  dynamic year = (now.year).toString();
//  dynamic month = (now.month).toString();
//  dynamic day = (now.day).toString();
  return appVersion;
}

void _unbind(context) async {
  // 点击解除绑定清空绑定信息
  serviceUrl = '';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('project');
  prefs.remove('projectName');
  if (prefs.containsKey('token')) {
    prefs.remove('token');
    prefs.remove('menus');
    prefs.remove('userName');
    prefs.remove('postName');
    prefs.remove('userId');
    prefs.remove('departmentName');
    prefs.remove('phoneNum');
  }
  Navigator.pop(context);
  Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => BarcodeScan()
  ));
}