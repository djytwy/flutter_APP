import 'package:flutter/material.dart';

class ModifyPassword extends StatefulWidget {
  ModifyPassword({Key key}) : super(key: key);

  _ModifyPasswordState createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> { 
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.white);
  var hintTips = new TextStyle(fontSize: 16.0, color: Colors.blue);
  @override
  
  Widget build(BuildContext context) {
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
                child: Column(
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(right: 24.0,left: 24.0),
                      child: new Container(
                        color: Color(0XFF0D1C31),
                        margin: new EdgeInsets.only(top: 24.0),
                        child: new TextField(
                          // controller: _userPhoneController,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),               
                            labelText: "输入手机号",
                            labelStyle: TextStyle(color: Color(0xFFffffff)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(right: 24.0,left: 24.0),
                      child: new Container(
                        color: Color(0XFF0D1C31),
                        margin: new EdgeInsets.only(top: 24.0),
                        child: new TextField(
                          // controller: _userPhoneController,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),               
                            labelText: "输入手机号",
                            labelStyle: TextStyle(color: Color(0xFFffffff)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(right: 24.0,left: 24.0),
                      child: new Container(
                        color: Color(0XFF0D1C31),
                        margin: new EdgeInsets.only(top: 24.0),
                        child: new TextField(
                          // controller: _userPhoneController,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),               
                            labelText: "输入手机号",
                            labelStyle: TextStyle(color: Color(0xFFffffff)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
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
                        print('修改密码');
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