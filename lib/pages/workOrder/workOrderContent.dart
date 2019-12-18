// 我的工单
import 'dart:io';
import 'package:app_tims_hotel/services/pageHttpInterface/workOrderContent.dart';
import 'package:flutter/material.dart';
import '../../components/listItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/textField.dart';
import '../../components/ButtonsComponents.dart';    // 下方两个按钮组件
import '../../components/buttonGroup.dart';  // 下方弹出按钮组件
import '../../utils/util.dart';
import '../../utils/eventBus.dart';
import './backReason.dart';// 退单原因
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/serviceUrl.dart';
import 'view/copierItem.dart';

// 预览图片的组件
class Preview extends StatelessWidget {
  Preview({
    Key key,
    this.imgFile,
    this.index,
    this.previewCallBack
  }) : super(key: key);

  final File imgFile;   // 图片
  final int index;  // 该图片对应在数组的ID
  final previewCallBack; // 点击×的回调函数
  
  @override
  Widget build(BuildContext context) {
    return imgFile != null ? Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 5.0,
            width: ScreenUtil.getInstance().setWidth(88),
            height: ScreenUtil.getInstance().setHeight(88),
            child: Image.file(imgFile)
          ),
          Positioned(
            left: 18.0,
            top: -18.0,
            child: IconButton(
              iconSize: ScreenUtil.getInstance().setHeight(35),
              color: Colors.red,
              icon: Icon(Icons.close),
              onPressed: (){
                _previewCallBack(index);
              },
            ),
          ),
        ],
      ),
      height: ScreenUtil.getInstance().setHeight(110),
      width: ScreenUtil.getInstance().setWidth(105),
    ) : Text('');
  }

  void _previewCallBack(index){
    previewCallBack(index);
  }
}

class WorkOrderContent extends StatefulWidget {
  WorkOrderContent({
    Key key,
    this.orderID
  }) : super(key: key);
  final orderID;

  _WorkOrderContentState createState() => _WorkOrderContentState();
}

class _WorkOrderContentState extends State<WorkOrderContent> {
  bool flag = true;   // 是否隐藏完成时限
  // 初始化页面数据
  dynamic pageData = {
    "areaName": "",
    "addTime": "",
    "sendUserName": "",
    "priority": 1,
    "taskContent": "",
    "taskType": 1,
    "anticipatedTime": 1,
    "rebuild": ""
  };

  List picList = [];  // 处理后图片
  List imageList = []; // 图片列表
  List uploadImgList = []; // 上传后收到的url
  int imageNum=0;  // 图片数量

  Map warningMap = { 1:'低', 2:'中' ,3:'高'};   // 紧急程度
  List statusList = ['处理中', '新建' ,'已完成', '待验收', '退单中', '无法处理', '挂起'];   // 任务状态列表
  String info;  // 备注   
  bool admin = false; //管理员权限
  bool repair = false; // 报修权限
  List copierList = []; // 抄送人的id
  Map _dicColors = {
    '空脏':Color.fromARGB(255, 239, 111, 111),
    '住脏':Color.fromARGB(255, 239, 111, 111),
    '空净':Color.fromARGB(255, 111, 185, 239),
    '住净':Color.fromARGB(255, 111, 185, 239),
    '锁门': Color.fromARGB(255, 239, 152, 111),
    '维修': Color.fromARGB(255, 239, 152, 111),
  };

  // 处理前照片
  dynamic picListBefore = [];

  void _getText(content) {
    setState(() {
      info = content;
    });
  }
  // 初始化权限
  initAuth() async{
    Map auth = await getAllAuths();
    setState(() {
      admin = auth['admin'];
      repair = auth['repair'];
    });
  }

  void _returnOrder() async {
    var val = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ChargReason(orderID:widget.orderID,copyUser: copierList)
    ));
    if(val != null){
      if(admin){
        // 刷新 换班信息
        bus.emit("refreshTask");
      }
      // 接上面路由继续跳一次
      Navigator.pop(context, true);
    }
  }

  void _submit() {
    if(pageData["taskPhotograph"].toString() == "1" && uploadImgList.length == 0) {
      showTotast('这个工单需要上传照片，请上传照片！');
    } else {
      getLocalStorage('userId').then((val) {
        var data= {
          "id": widget.orderID,
          "now_userId": int.parse(val), 
          "optionType":2,       // 2代表已完成
          "pictureUrlList": uploadImgList,
          "info": info,
          "copyUser": copierList
        };
        submitData(data).then((val) {
          if(repair){
            // 刷新 换班信息
            bus.emit("refreshTask");
          }
          showTotast('提交成功！');
          Navigator.pop(context, true);
          // Navigator.pushReplacementNamed(context, '/submitWorkOrder');
        });
      });
    }
  }

  void getImage(file)  {
    if(file != null) {
      uploadImg(file).then((val) {
        setState(() {
          imageList.add(file);
          uploadImgList.add(val["filePath"]);
        }); 
      });
    }
  }

  void delImage(index) {
    setState(() {
      uploadImgList.removeAt(index);
      imageList.removeAt(index);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    initAuth();
    getLocalStorage('userId').then((val){
      String userID = val;
      dynamic taskID = widget.orderID;

      getData(taskID=taskID,userID=userID).then((val) {
        dynamic _TpicList = [];
        dynamic _TpicListBefore = [];
        if(val["mainInfo"]["taskPictureInfo"]["afterProcessing"] is List ) {
          _TpicList = val["mainInfo"]["taskPictureInfo"]["afterProcessing"].
          map((each) => serviceUrl+each['picUrl'].toString());
        }

        if(val["mainInfo"]["taskPictureInfo"]["beforeProcessing"] is List ) {
          _TpicListBefore = val["mainInfo"]["taskPictureInfo"]["beforeProcessing"].
          map((each) => serviceUrl+each['picUrl'].toString());
        }

        if(val!=null || val.containsKey("areaName"))
          setState(() {
            picList = _TpicList.toList();
            picListBefore = _TpicListBefore.toList();
            pageData = val["mainInfo"];
            flag = val["mainInfo"]["taskType"] != 0 ? true : false;
          });
      });
    });
  }

  // 时间转换函数
  String _converTime(time) {
    // 后台出错前端不红屏
    if (time == null || time == '') time ='2019-08-22 06:45:42';
    DateTime _time = DateTime.parse(time);
    final nowDay = DateTime.now();
    final yesterday = nowDay.subtract(Duration(days: 1));
    int hour = _time.hour;
    int minute = _time.minute;
    String _hour = addZero(hour);
    String _minute = addZero(minute);
    if (_time.day == nowDay.day && _time.month == nowDay.month && _time.year == nowDay.year) {
      return '$_hour:$_minute';
    } else if (_time.day == yesterday.day && _time.month == yesterday.month && _time.year == yesterday.year) {
      return '昨天 $_hour:$_minute';
    } else
      return time;
  }

  // 回调函数获得选中的抄送人ID
  void _getCopierID(List _copierList) {
    dynamic tempList = _copierList.map((e) => e["userID"]);
    setState(() {
      copierList = tempList.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    double fontSize = ScreenUtil.getInstance().setSp(30);
    //报修人
    String reporter = pageData['sendUserName'];
    if(pageData['sendDepartment'] != null){
      String sendDepartment = pageData['sendDepartment'];
      reporter = reporter + ' ($sendDepartment)';
    } 
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent, 
          title: Center(
            child: Text('工单内容',style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)))
          ),
          actions: <Widget>[
            Container(
              width: ScreenUtil.getInstance().setWidth(150),
              child: FlatButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        child: ButtonGroup(
                          titleList: ["转给他人验收"],
                        ),
                      );
                    }
                  );
                },
                child: Offstage(
                  offstage: true,
                  child: Text('更多',style: TextStyle(color: Colors.blue)),
                )
              )
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // 列表显示条
              Container(
                margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(16)),
                child: Column(
                  children: <Widget>[
                    ListItem(title: '地点', content: pageData["areaName"], border: true, labelWidget: StatusButton(color: _dicColors[pageData['roomState']], label: pageData['roomState'])),
                    ListItem(title: '时间', content: _converTime(pageData["addTime"]),border: true),
                    Offstage(
                      offstage: !pageData.containsKey("sendDepartment") || pageData["sendUserName"] == null,
                      child: ListItem(
                        title: '报修人', 
                        content: reporter,
                        border: true, phone: false, phoneNum: pageData['sendUserPhone']
                      ),
                    ),
                    ListItem(title: '优先级', content: warningMap[pageData["priority"]],border: true),
                  ],
                )
              ),
              // 抄送人
              CopierItem(clickCB: _getCopierID),
              // 内容
              Container(
                margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(22)),
                color: Color.fromARGB(100, 12, 33, 53),
                height: ScreenUtil.getInstance().setHeight(220),
                child: Column(
                  children: <Widget>[
                    Offstage(
                      offstage: pageData["deviceName"] == null || pageData["deviceName"] == "",
                      child: ListItem(title: '设备', content: pageData["deviceName"] == null || pageData["deviceName"] == "" ? "暂无" : pageData["deviceName"]),
                    ),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(30)),
                      alignment: Alignment.centerLeft,
                      child: Text('内容',style: TextStyle(fontSize: fontSize,color: Colors.white70)),
                    ),
                    Container(
                      width: ScreenUtil.getInstance().setWidth(690),
                      child: Text(pageData['taskContent'], maxLines: 5,style: TextStyle(fontSize: fontSize,color: Colors.white)),
                    ),
                  ],
                ),
              ),
              // 重修(重修的时候才会有)
              Offstage(
                offstage: pageData["rebuild"] == "" || pageData["rebuild"] == null,
                child: Container(
                  margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(22)),
                  color: Color.fromARGB(100, 12, 33, 53),
                  height: ScreenUtil.getInstance().setHeight(220),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(30)),
                        alignment: Alignment.centerLeft,
                        child: Text('重修原因',style: TextStyle(fontSize: fontSize,color: Colors.white70)),
                      ),
                      Container(
                        width: ScreenUtil.getInstance().setWidth(690),
                        child: Text(pageData["rebuild"] == null? "" : pageData['rebuild'], maxLines: 5,style: TextStyle(fontSize: fontSize,color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              // 备注
              Container(
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  ScreenUtil.getInstance().setHeight(22),
                  0.0,
                  ScreenUtil.getInstance().setHeight(22),
                ),
                color: Color.fromARGB(100, 12, 33, 53),
                height: ScreenUtil.getInstance().setHeight(220),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(30)),
                      alignment: Alignment.centerLeft,
                      child: Text('备注',style: TextStyle(fontSize: fontSize,color: Colors.white70)),
                    ),
                    Container(
                      width: ScreenUtil.getInstance().setWidth(690),
                      child: CustTextField(fontSize: fontSize,placeHolder: '请输入备注，最多50字',textCallBack: (r) => _getText(r))
                    ),
                  ],
                ),
              ),
              // 现场照片
              Offstage(
                offstage: picListBefore.length == 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(30)),
                  child: Text('现场照片', style: TextStyle(color:Colors.white)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: boxs(picListBefore ,picListBefore.length),
                ),
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  ScreenUtil.getInstance().setHeight(20),
                  0.0,
                  ScreenUtil.getInstance().setHeight(20)
                ),
              ),
              // 处理后照片
              Offstage(
                offstage: picList.length == 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(30)),
                  child: Text('处理后照片', style: TextStyle(color:Colors.white)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: boxs(picList ,picList.length),
                ),
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  ScreenUtil.getInstance().setHeight(20),
                  0.0,
                  ScreenUtil.getInstance().setHeight(20)
                ),
              ),
              // 完成时限
              Offstage(
                offstage: !flag,
                child: ListItem(
                  title: '完成时限', 
                  content: pageData.containsKey("anticipatedTime")? pageData["anticipatedTime"].toString() + '天': '暂无',
                  color: Colors.greenAccent
                ),
              ),
              ListItem(title: '上传照片', content: '', background: Colors.transparent,marginTop: ScreenUtil.getInstance().setHeight(10)),
              // 照片预览
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: ScreenUtil.getInstance().setHeight(110),
                      child: ListView.builder(
                        scrollDirection:Axis.horizontal,
                        itemCount: imageList.length,
                        itemBuilder: (context, index) {
                          return Preview(
                            imgFile: imageList[index], 
                            index: index,
                            previewCallBack: (index) => delImage(index),
                          );
                        },
                      ),
                    )
                  ),
                  // 添加照片按钮
                  Container(
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: (){
                        showModalBottomSheet(   
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              child: ButtonGroup(
                                context2: context,
                                titleList: ["拍照","相册"],
                                imageCallback: (imgFile) => getImage(imgFile)
                              ),
                            );
                          }
                        );
                      },
                    ),
                  )
                ],
              ),
              ListItem(
                title: '工单号码：' + pageData["ID"].toString(), 
                content: '',
                background: Colors.transparent,
                marginTop: ScreenUtil.getInstance().setHeight(10),
                color: Colors.white70,
              ),
              ButtonsComponents(
                cbackLeft: _returnOrder,
                cbackRight: _submit,
                leftName: '退单',
                rightName: '提交',
              )
            ]
          )
        )
      ),
    ); 
  }

  List<Widget> boxs(_picList,length) => List.generate(length, (index) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(360),
      height: ScreenUtil.getInstance().setHeight(270),
      alignment: Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: _picList[index],
          width: ScreenUtil.getInstance().setWidth(340),
          height: ScreenUtil.getInstance().setHeight(255),
          fit: BoxFit.cover,
        )
      )
    );
  });
}


class StatusButton extends StatelessWidget {
  StatusButton({
    Key key,
    this.color,
    this.label
  }):super();
  final color;
  final label;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Container(
      margin: EdgeInsets.only(right: ScreenUtil.instance.setWidth(60)),
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.all(Radius.circular(3))
        ),
        width: ScreenUtil.instance.setWidth(80),
        height: ScreenUtil.instance.setHeight(40),
        child: Center(
          child: Text(this.label ?? "",style: TextStyle(color: Colors.white)),
        )
      )
    );
  }
}