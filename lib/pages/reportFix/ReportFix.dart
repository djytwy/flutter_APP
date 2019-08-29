import '../../services/pageHttpInterface/ReportFix.dart';
import 'package:flutter/material.dart';
import '../../components/textField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import '../../components/picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/util.dart';

class ReportFix extends StatefulWidget {
  ReportFix({Key key}) : super(key: key);

  _ReportFixState createState() => _ReportFixState();
}

class _ReportFixState extends State<ReportFix> {

  // String pickerDataPlace = '''[
  //   {"一楼拐角处":[{"这是一楼":[1,2,3]},{"这是二楼":[""]}]},
  //   {"二楼拐角处":[{"这是一一楼":[14,63,35]},{"这是二二楼":[144,243,223]}]}
  // ]''';
  String pickerDataPlace = '''''';
  String pickerDataGrade = '''["高","中","低"]''';
  String pickerDataCamera = '''["是","否"]''';
  String pickerDataPeople = '''["数据噢诶发","胡海峰为","焦宏伟规划"]''';

  dynamic userIDList;          // 用户ID的列表

  Object placeIdList;       // ID的数据 
  var placeID;              // 选中的地点ID

  String content;           // 文本框的内容
  String place;             // 地点
  String grade;             // 优先级
  String people;            // 抄送人
  String camera;            // 是否拍照
  dynamic userId;            // 用户ID

  @override
  void initState() {
    getData().then((val) {
      setState(() {
        pickerDataPlace = json.encode(val);
      });
    });

    getPlaceID().then((val) {
      setState(() {
        placeIdList = val;
      });
    });

    getUser().then((val) {
      setState(() {
        pickerDataPeople = jsonEncode(val);
      });
    });

    getUserID().then((val) {
      setState(() {
        userIDList = val;
      });
    });
    getLocalStorage('userId').then((val) {
      setState(() {
        userId = val;
      });
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);  // 以苹果6适配
    double fontSize = ScreenUtil.getInstance().setSp(30);   // 默认字体大小

    void getContent(nowContent){
      setState(() {
        content = nowContent;
      });
    }

    void pickerPlace(data, value) {
      dynamic temp = placeIdList;
      for (var i in value) {
        if (temp is List) {
          if(temp[i] == "") 
            break;
          else 
            temp = temp[i];
        } else if (temp is Map) {
          if(temp.values.toList()[0][i] == "")
            break;
          else
            temp = temp.values.toList()[0][i];
        }
      }
      setState(() {
        placeID = temp is Map? temp.keys.toList()[0]: temp;
        place = data;
      });
      print('数据： $data,$value,  id: $placeID');
    }

    void pickerGrade(data, value) {
      setState(() {
        grade = data;
      });
    }

    void pickerCamera(data, value) {
      setState(() {
        camera = data;
      });
    }

    void pickerPeople(data, value) {
      var result;
      print(userIDList);
      result = userIDList[value[0]].values.toList()[0][value[1]];
      setState(() {
        people = result.toString();
      });
    }

    void _showToast(){
      Fluttertoast.showToast(
        msg: "派单成功",
        toastLength: Toast.LENGTH_SHORT,
        // backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER
      );
    }

    void submitData() {
      // getData().then((val) {
      //   print(val);
      // });
      var gradeList = {"高":'3','中':'2','低':'1'};
      var photo = {"是":"1","否":"0"};
      var data = {
        'sendUserId':userId,       // 测试用户
        'taskPlace':placeID,
        'taskPriority':gradeList[grade],
        'taskPhotograph':photo[camera],
        'taskContent':content,
        'copyUser': people == null ? [] : [int.parse(people)]
      };

      postData(data).then((val) {
        _showToast();
        Navigator.pop(context);
      });
    }

    return Container(
      child: Scaffold(
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
                    color: Color(0x60000000)             
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
                          pickerCallback: (data, value) => pickerPlace(data, value),
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
                    color: Color(0x60000000)             
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(child: Text('工单描述', style: TextStyle(fontSize: fontSize,color: Colors.white70))),
                      Container(child: CustTextField(fontSize: fontSize, placeHolder: '请输入工单描述',textCallBack: (r) => getContent(r),)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0x60000000)             
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
                          pickerCallback: (data,value) => pickerGrade(data,value),
                        ),
                      )
                    ],
                  ),
                ),  
                Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0x60000000)             
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text('抄送人',textAlign: TextAlign.left,style: TextStyle(fontSize: fontSize,color: Colors.white70),)
                      ),
                      Expanded(
                        child: CustPicker(
                          itemsString: pickerDataPeople, 
                          scaffoldKey: _scaffoldKey, 
                          pickerCallback: (data, value) => pickerPeople(data, value),
                          textWidth: 530,
                          iconWidth: 60,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(0x60000000)             
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
                          pickerCallback: (data,value) => pickerCamera(data,value),
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