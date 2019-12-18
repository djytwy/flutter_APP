import 'package:flutter/material.dart';
import '../utils/util.dart';
import '../services/pageHttpInterface/Login.dart';
import './Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifyPassword extends StatefulWidget {
  ModifyPassword({Key key}) : super(key: key);

  _ModifyPasswordState createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.white);
  var hintTips = new TextStyle(fontSize: 16.0, color: Colors.blue);

  var userId; //用户id
  String oldPassword;//原密码
  String password; //新密码
  String rePassword; //确认新密码
  @override
  void initState(){
    super.initState();
    getLocalStorage('userId').then((vlaue){
      setState(() {
        userId = vlaue;
      });
    });
  }
  // 修改密码
  void updatePassword() async{
    var params = {
      'operFlag': 5,
      'userID': userId,
      'oldPassword': oldPassword, //原密码
      'password': password, //新密码
      'rePassword': rePassword //确认新密码
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(oldPassword == null){
      showTotast('请输入原密码！');
      return;
    }
    if(password == null){
      showTotast('请输入新密码！');
      return;
    }
    if(rePassword == null){
      showTotast('请输入确认密码！');
      return;
    }
    if (password != rePassword) {
      showTotast('2次输入密码不一致！');
      return;
    }
    if (oldPassword == rePassword) {
      showTotast('新密码不能和原密码一样！');
      return;
    }
    getmodifyPassword(params).then((data){
      print(data);
      if(data != null && data){
        prefs.remove('token');
        prefs.remove('menus');
        prefs.remove('userName');
        prefs.remove('postName');
        prefs.remove('userId');
        prefs.remove('departmentName');
        prefs.remove('phoneNum');
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => new Login()
        ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return new Container(
      height: height,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('修改密码', style: TextStyle(fontSize: 18),),
          centerTitle: true,
          backgroundColor: Colors.transparent
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: _adapt.setWidth(20), right: _adapt.setWidth(20)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: _adapt.setHeight(20)),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(13, 28, 49, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: _adapt.setWidth(20), right: _adapt.setWidth(20), top: _adapt.setHeight(15), bottom: _adapt.setHeight(15)),
                              width: _adapt.setWidth(110),
                              child: Text('原密码',  style: TextStyle(color: Color.fromRGBO(99, 126, 165, 1), fontSize: _adapt.setFontSize(16), letterSpacing: _adapt.setWidth(5))),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    oldPassword = newValue;
                                  });
                                },
                                style:TextStyle(fontSize: _adapt.setFontSize(16), color: Colors.white),
                                decoration: new InputDecoration(
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelStyle: TextStyle(color: Color(0xFFffffff)),
                                  border: InputBorder.none,
                                  hintText: '请输入原密码',
                                  hintStyle: TextStyle(color: Color.fromRGBO(184, 193, 200, 1)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: _adapt.setHeight(20)),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(13, 28, 49, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: _adapt.setWidth(20), right: _adapt.setWidth(20), top: _adapt.setHeight(15), bottom: _adapt.setHeight(15)),
                              width: _adapt.setWidth(110),
                              child: Text('新密码', style: TextStyle(color: Color.fromRGBO(99, 126, 165, 1), fontSize: _adapt.setFontSize(16), letterSpacing: _adapt.setWidth(5))),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    password = newValue;
                                  });
                                },
                                style:TextStyle(fontSize: _adapt.setFontSize(16), color: Colors.white),
                                decoration: new InputDecoration(
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelStyle: TextStyle(color: Color(0xFFffffff)),
                                  border: InputBorder.none,
                                  hintText: '请输入新密码',
                                  hintStyle: TextStyle(color: Color.fromRGBO(184, 193, 200, 1)),
                                )
                              )
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: _adapt.setHeight(20)),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(13, 28, 49, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: _adapt.setWidth(20), right: _adapt.setWidth(20), top: _adapt.setHeight(15), bottom: _adapt.setHeight(15)),
                              width: _adapt.setWidth(110),
                              child: Text('确认密码', style: TextStyle(color: Color.fromRGBO(99, 126, 165, 1), fontSize: _adapt.setFontSize(16))),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    rePassword = newValue;
                                  });
                                },
                                style:TextStyle(fontSize: _adapt.setFontSize(16), color: Colors.white),
                                decoration: new InputDecoration(
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelStyle: TextStyle(color: Color(0xFFffffff)),
                                  border: InputBorder.none,
                                  hintText: '请再次输入新密码',
                                  hintStyle: TextStyle(color: Color.fromRGBO(184, 193, 200, 1)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: new Container(
                  width: width,
                  height: 60.0,
                  margin: new EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 40.0),
                  padding: new EdgeInsets.only(right: 24.0,left: 24.0),
                  child: new Card(
                    color: Colors.blue,
                    elevation: 6.0,
                    child: new FlatButton(
                      onPressed: () {
                        updatePassword();
                      },
                      child: new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Text(
                          '确认修改',
                          style:
                          new TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    )
                  ),
                ),
              )
            ],
          ),
        ),
        resizeToAvoidBottomPadding: false
      ),
    );
  }
}