import 'package:flutter/material.dart';
import '../components/textField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import '../components/picker.dart';
import '../services/serviceMethod.dart';

class ReportFix extends StatefulWidget {
  ReportFix({Key key}) : super(key: key);

  _ReportFixState createState() => _ReportFixState();
}

class _ReportFixState extends State<ReportFix> {

  String pickerDataPlace = '''[
    {"一楼拐角处":[{"这是一楼":[1,2,3]},{"这是二楼":[11,23,23]}]},
    {"二楼拐角处":[{"这是一一楼":[14,63,35]},{"这是二二楼":[144,243,223]}]}
  ]''';
  String pickerDataGrade = '''["高","中","低"]''';
  String pickerDataCamera = '''["是","否"]''';

  String content;           // 文本框的内容
  String place;             // 地点
  String grade;             // 优先级
  String people;            // 抄送人
  String camera;            // 是否拍照

  // final pickerData = '''
  //   [{"见附件文件":[{"a1":[1,2,3,4]},{"a2":[5,6,7,8]},{"a3":[9,10,11,12]}]},{"b":[{"b1":[11,22,33,44]},{"b2":[55,66,77,88]},{"b3":[99,1010,1111,1212]}]},{"c":[{"c1":["a","b","c"]},{"c2":["aa","bb","cc"]},{"c3":["aaa","bbb","ccc"]}]}]
  // ''';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);  // 以苹果6适配
    double fontSize = ScreenUtil.getInstance().setSp(30);   // 默认字体大小

    void getContent(nowContent){
      setState(() {
        // content = nowContent;
        content = nowContent;
      });
      print('111内容：$content');
    }

    void pickerPlace(data) {
      setState(() {
        place = data;
      });
    }

    void pickerGrade(data) {
      setState(() {
        grade = data;
      });
    }

    void pickerCamera(data) {
      setState(() {
        camera = data;
      });
    }

    void submitData() {
      testGet().then((val) {
        print(val);
      });
      // print('$camera,$content,$grade,$place ,$people');
    }

    return Container(
      child: Scaffold(
        // floatingActionButton:Container(
        //   child: FlatButton(
        //     child: Text('提交',style: TextStyle(color: Colors.white)),
        //     onPressed: (){print('dda');},
        //   ),
        //   width: ScreenUtil.getInstance().setWidth(620),
        //   decoration: BoxDecoration(
        //     color: Colors.blueAccent,
        //     borderRadius: BorderRadius.circular(15.0)
        //   ),
        // ),

        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // elevation: 0,  // 取消appbar的颜色
          title: Center(child: Text('报修工单', style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)),)),
          actions: <Widget>[
            Container(
              child: IconButton(
                icon: const Icon(Icons.add_call),
                tooltip: '语音识别',
                onPressed: (){
                  // 进入语音识别界面
                },
              ),
            ),
          ],  
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 50.0,
                  margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  decoration: BoxDecoration(
                    color: Color(0x90000000)             
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('地点',textAlign: TextAlign.left,style: TextStyle(fontSize: fontSize,color: Colors.white70),)
                      ),
                      Expanded(
                        child: CustPicker(
                          itemsString: pickerDataPlace, 
                          scaffoldKey: _scaffoldKey, 
                          pickerCallback: (data) => pickerPlace(data),
                          textWidth: 550,
                          iconWidth: 60,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0x90000000)             
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(child: Text('工单描述', style: TextStyle(fontSize: fontSize,color: Colors.white70))),
                      Container(child: CusTextField(fontSize: fontSize,textCallBack: (r) => getContent(r),)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0x90000000)             
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text('工单优先级',textAlign: TextAlign.left,style: TextStyle(fontSize: fontSize,color: Colors.white70))
                      ),
                      Expanded(
                        child: CustPicker(
                          itemsString: pickerDataGrade, 
                          scaffoldKey: _scaffoldKey, 
                          textWidth: 475,
                          iconWidth: 60,
                          pickerCallback: (data) => pickerGrade(data),
                        ),
                      )
                    ],
                  ),
                ),  
                Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0x90000000)             
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text('抄送人',textAlign: TextAlign.left,style: TextStyle(fontSize: fontSize,color: Colors.white70),)
                      ),
                      Expanded(child: Text('青羊区13栋',textAlign: TextAlign.right))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0x90000000)             
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text('是否拍照',textAlign: TextAlign.left,style: TextStyle(fontSize: fontSize,color: Colors.white70))
                      ),
                      Expanded(
                        child: CustPicker(
                          itemsString: pickerDataCamera, 
                          scaffoldKey: _scaffoldKey, 
                          textWidth: 505,
                          iconWidth: 60,
                          pickerCallback: (data) => pickerCamera(data),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(450)),
                  child: FlatButton(
                    child: Text('提交',style: TextStyle(color: Colors.white)),
                    onPressed: submitData,
                  ),
                  width: ScreenUtil.getInstance().setWidth(620),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                ),
              ],
            ),
          ),
        )
        
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        )
      ),
    );
  }
}