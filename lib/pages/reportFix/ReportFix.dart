import 'dart:async';
import 'package:flutter/painting.dart';

import '../../services/pageHttpInterface/ReportFix.dart';
import 'package:flutter/material.dart';
import '../../components/textField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import '../../components/picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/util.dart';

import './copierDepartment.dart';
import './view/copierList.dart';
import '../../utils/eventBus.dart';
// 图片上传组件
import '../../components/customImgPicker.dart';
// 图片预览组件
import 'view/previewImg.dart';

class ReportFix extends StatefulWidget {
  ReportFix({
    Key key,
    this.navigatorkeyContext,
  }) : super(key: key);
  final navigatorkeyContext;

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

  Object placeIdList;       // ID的数据 
  var placeID;              // 选中的地点ID

  String content;           // 文本框的内容
  String place;             // 地点
  String grade = '中';      // 优先级
  String camera = '否';            // 是否拍照
  dynamic userId;            // 用户ID

  bool _contentFlag = false;  // 文本输入框的控制标志
  dynamic _content;    // 文本框数据

  bool _placeFlag = false;  // 地点的控制标志
  dynamic _place;  // 地点
  bool _gradeFlag = false;  // 优先级的控制标志
  dynamic _grade;  // 优先级
  bool _cameraFlag = false;     // 相机的控制标志
  dynamic _camera; // 相机（是、否）
  List defaulttCopierList = []; //默认抄送人列表
  List copierList = []; //抄送人列表-- 包含部门
  List copierUsers = []; //抄送人列表-- 不包含部门
  List copierIds = []; //抄送人id
  List copierSelects = []; //抄送人的列表-用于显示名字
  List pictureList = [];  // 现场图片的list
  List postPicture = [];  // 用于上传图片的URL列表

  @override
  void initState() {
    // 获取抄送人列表
    getCopierList().then((data){
      if (data != null) {
        List users = [];
        // 把所以抄送人从部门里面取出来
        data.forEach((item){
          if (item['childs'] != null && item['childs'].length > 0) {
            users.addAll(item['childs']);
          }
        });
        setState(() {
          copierList = data;
          copierUsers = users;
        });
      }
    });
    // 获取默认抄送人
    getDefaulttCopierList().then((data){
      if(data != null && data is List) {
        var list = [];
        data.forEach((item){
          list.add({
            'isNoDel': true,
            'userName': item['userName'],
            'userID': item['userId']
          });
        });
        setState(() {
          defaulttCopierList = list;
          copierSelects = list;
        });
      }
    });
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

    getLocalStorage('userId').then((val) {
      setState(() {
        userId = val;
      });
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 删除抄送人
  void delCopier(item){
    List list = [];
    List ids = [];
    List copierLists = [];
    // 清空选中的id, 和 列表数据中 selectList
    copierSelects.forEach((itemx){
      if (item['userID'] != itemx['userID']) list.add(itemx);
    });
    copierIds.forEach((itemx){
      if (item['userID'] != itemx) ids.add(itemx);
    });
    // 抄送列表，包含id
    copierList.forEach((itemx){
      if(itemx['selectList'] != null && itemx['selectList'].contains(item['userID'])){
        itemx['selectList'].remove(item['userID']);
      }
      copierLists.add(itemx);
    });
    setState(() {
      copierIds = ids;
      copierSelects = list;
      copierList = copierLists;
    });
  }
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
      Map gradeList = {"高":'3','中':'2','低':'1'};
      Map photo = {"是":"1","否":"0"};
      if (camera == null) {
        showTotast('请选择是否拍照!');
      } else {
        Map data = {
          'sendUserId':userId,       // 测试用户
          'taskPlace':placeID,
          'taskPriority':gradeList[grade],
          'taskPhotograph':photo[camera],
          'taskContent':content,
          'copyUser': copierIds,
          'picture': postPicture
        };
        showAlertDialog(context, text: '是否确认提交工单？', onOk: (){
          postData(data).then((val) async {
            if (val != null) {
              _showToast();
              print('---推送消息----');
              bus.emit('refreshMenu');
              Navigator.pop(context);
            }
          });
        });
      }
    }

    // 语音识别后设置文字
    Future _setCheckText(result, key) async {
      switch (key) {
        case 'taskContent':
          setState(() {
            _contentFlag = true;
            _content = result[key];
          });
          break;
        case 'taskPlaceName':
          setState(() {
            _place = result[key];
            _placeFlag = true;
          });
          break;
        case 'taskPhotograph':
          setState(() {
            _camera = result[key] == 0 ? '否' : '是';
            _cameraFlag = true;
          });
          break;
        case 'taskPriority':
          setState(() {
            _grade = result[key] == 3 ? '高' : result[key] == 2 ? '中' : '低';
            _gradeFlag = true; 
          });
          break;
        default:
          print('错误！');
      }
      return null;
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
                icon: const Icon(Icons.keyboard_voice),
                tooltip: '语音识别',
                onPressed: () async {
                  dynamic result = await Navigator.pushNamed(context, '/voiceRecognize');
                  if(result != null && !result.containsValue(null)){
                    /* 识别成功则设置界面的数据，设置数据的思路是先将父组件的值传入子组件触发子组件的更新事件，
                    传子组件的控制变量设置为true，20毫秒间隔后，再将它设置为false，这样避免每次更新都修改子组件的值。*/
                    List keyList = ["taskPlaceName", "taskPhotograph", "taskPriority", 'taskContent'];
                    const ms20 = Duration(milliseconds: 20);
                    for(var item in keyList)
                      switch (item) {
                        case 'taskPlaceName':
                          _setCheckText(result, item).then((val) {
                            Timer(ms20, (){
                              setState(() {
                                placeID = result["taskPlace"];
                                _placeFlag = false;
                              });
                            });
                          });
                          break;
                        case 'taskPhotograph':
                          _setCheckText(result, item).then((val) {
                            Timer(ms20, (){
                              setState(() {
                                camera = _camera;
                                _cameraFlag = false;
                              });
                            });
                          });
                          break;
                        case 'taskPriority':
                          _setCheckText(result, item).then((val) {
                            Timer(ms20, (){
                              setState(() {
                                grade = _grade;
                                _gradeFlag = false; 
                              });
                            });
                          });
                          break;
                        case 'taskContent':
                          _setCheckText(result, item).then((val) {
                            Timer(ms20, (){
                              setState(() {
                                content = _content;
                                _contentFlag = false;
                              });
                            });
                          });
                          break;
                        default: print('错误！');
                      }
                  } 
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
                          flag: _placeFlag,
                          setData: _place,
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
                      Container(child: CustTextField(
                        fontSize: fontSize, placeHolder: '请输入工单描述',
                        textCallBack: (r) => getContent(r),
                        setText: _content,
                        flag: _contentFlag,
                      )),
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
                          textWidth: 477,
                          iconWidth: 60,
                          pickerCallback: (data,value) => pickerGrade(data,value),
                          flag: _gradeFlag,
                          setData: _grade,
                          defaultGrade: '中',
                        ),
                      )
                    ],
                  ),
                ), 
                Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                  decoration: BoxDecoration(
                    color: Color(0x60000000)             
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: ScreenUtil.getInstance().setWidth(30)
                          ),
                          child: Text('抄送人',textAlign: TextAlign.left,style: TextStyle(fontSize: fontSize,color: Colors.white70),)
                        ),
                      ),
                      CopierList(data: copierSelects, delCopier: delCopier, pageCback: () async {
                          var val = await Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => CopierDepartment(data: copierList)
                                ));
                          if (val != null) {
                            List list = [];
                            // 根据id 获取名字
                            val['selects'].forEach((item){
                              copierUsers.forEach((itemx){
                                  if (item == itemx['userID']) {
                                    list.add(itemx);
                                  }
                              });
                            });
                            // 根据返回的数据赋值
                            setState(() {
                              copierList = val['data'];
                              copierIds = val['selects'];
                              copierSelects = [...defaulttCopierList, ...list];
                            });
                          }
                      })
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
                        child: Text('处理后拍照上传',textAlign: TextAlign.left,style: TextStyle(fontSize: fontSize,color: Colors.white70))
                      ),
                      Expanded(
                        child: CustPicker(
                          itemsString: pickerDataCamera, 
                          scaffoldKey: _scaffoldKey, 
                          textWidth: 417,
                          iconWidth: 60,
                          pickerCallback: (data,value) => pickerCamera(data,value),
                          flag: _cameraFlag,
                          setData: _camera,
                          defaultGrade: '否',
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil.getInstance().setHeight(25),
                    top: ScreenUtil.getInstance().setHeight(10)
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text('上传现场图片:',style: TextStyle(color: Colors.white70)),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: ScreenUtil.getInstance().setHeight(110),
                          child: ListView.builder(
                            scrollDirection:Axis.horizontal,
                            itemCount: pictureList.length,
                            itemBuilder: (context, index) {
                              return Preview(
                                imgFile: pictureList[index],
                                index: index,
                                previewCallBack: (index) => _delImage(index),
                              );
                            },
                          ),
                        )
                      ),
                      GestureDetector(
                        child: Container(
                          color: Color(0x60000000),
                          child: Center(child: Icon(Icons.add,color: Colors.white)),
                          height: ScreenUtil.getInstance().setWidth(85),
                          width: ScreenUtil.getInstance().setWidth(85),
                        ),
                        onTap: (){
                          if(pictureList.length >= 2)
                            showTotast('现场图片最多上传两张 o(╥﹏╥)o');
                          else
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  // 设置高度215，避免报高度警告
                                  height: 200,
                                  child: CustomImgPicker(
                                    context: context,
                                    imageCallback: _getImg,
                                  )
                                );
                              }
                            );
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(100)),
                  child: FlatButton(
                    child: Text('报修',style: TextStyle(color: Colors.white)),
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

  // 上传图片的回调
  void _getImg(imageFile,data) {
    if (pictureList.length >= 2)
      showTotast("现场图片最多上传两张 o(╥﹏╥)o");
    else
      setState(() {
        pictureList.add(imageFile);
        postPicture.add(data["filePath"]);
      });
  }
  
  // 删除图片
  void _delImage(index) {
    setState(() {
      postPicture.removeAt(index);
      pictureList.removeAt(index);
    });
  }
}