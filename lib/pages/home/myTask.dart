// 我的任务页面
import 'dart:async';

import 'package:flutter/material.dart';
import '../../services/pageHttpInterface/MyTask.dart';
import '../../utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/eventBus.dart';
// 组件
import './view/ButtonBars.dart';
import '../Login.dart';
// 页面
import '../workOrder/workOrderList.dart';
import '../shiftDuty/addShiftDuty.dart';
import '../shiftDuty/approvalPendingList.dart';
import '../shiftDuty/approved.dart';
import '../shiftDuty/inApproval.dart';

// 新工单列表数量
import '../../services/pageHttpInterface/workOrderList.dart';
import '../ModifyPassword.dart';



class MyTask extends StatefulWidget {
  MyTask({Key key, this.orderID}) : super(key: key);
  final orderID;
  @override
  _MyTask createState() => _MyTask();
}
class _MyTask extends State<MyTask> {
  var userId; //用户id
  bool _work = false; //工单
  bool _shift = true; //排班
  int msgType = 2;
  //页面数据 -工单
  Map pageWorkOrderData = {
    'workOrderNum': 0,
    'repairNum': 0,
    'drawBackNum': 0,
    'newWorkOrderNum': 0,
    'hangWorkOrderNum': 0
  }; 
  //页面数据 -排班
  Map pageSchedulingData = {
      'beforeApproval': 0,
      'inApproval': 0,
      'afterApproval': 0,
      'myApproval': 0,
      'ordinaryApproval': 0
  };
  int dataNum;
  // 用户信息
  String _token = '';
  String _userName = '';
  String _postName = '';
  String _departmentName = '';
  String _phoneNum = '';
  // 默认 无权限
  bool admin = false; //管理员权限
  bool repair = false; // 报修权限
  bool keepInRepair = false; //维修权限
  bool addShiftDuty = false; //换班申请权限
  bool shiftDutyManage = false; //排班管理权限
  @override
  void initState(){
    super.initState();
    initAuth();
    _initUserInfo();
    getLocalStorage('userId').then((data){
      userId = (data is int) ? data : int.parse(data);
      getInitData();
    });
    //监听访问详情事件，来刷新通知消息
    const second = Duration(seconds: 2);
    bus.on("refreshTask", (arg) async {
      await Future.delayed(second);
      getInitData();
   });
  }
  @override
  void dispose() {
    super.dispose();
    bus.off("refreshTask");//移除广播监听
  }
  // 初始化权限
  initAuth() async{
    Map auth = await getAllAuths();
    setState(() {
      admin = auth['admin'];
      repair = auth['repair'];
      keepInRepair = auth['keepInRepair'];
      addShiftDuty = auth['addShiftDuty'];
      shiftDutyManage = auth['shiftDutyManage'];
    });
  }
  // 获取用户信息
  _initUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? '');
    });
    if (_token != '') {
      setState(() {
        _userName = (prefs.getString('userName') ?? '');
        _postName = (prefs.getString('postName') ?? '');
        _departmentName = (prefs.getString('departmentName') ?? '');
        _phoneNum = (prefs.getString('phoneNum') ?? '');
      });
    } 
  }
  // 退出登录
  void signOut() async{
    print('222');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('menus');
    prefs.remove('userName');
    prefs.remove('postName');
    prefs.remove('userId');
    prefs.remove('departmentName');
    prefs.remove('phoneNum');
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => new Test(
      )
    ));
  }
  // 获取初始化数据
  void getInitData(){
    Map<String, dynamic> params = {
      'userId': userId,
      'submodelId': 2,
      'msgType': msgType, // 类型 1:排班， 2： 工单
      'msgIsread': 0
      // 'msgStatus': 0  //子状态[100-新工单;101-我的工单;102-报修工单;103-退单]不传的时候取对应的所有
    };

    getMyTaskList(params).then((data) async {
      if(data is Map && params['msgType'] == 2) {
        dynamic _data = await getData("0","1", false, true);
        data["newWorkOrderNum"] = _data["list"].length;
        setState(() {
          pageWorkOrderData = data;
        });
      } else if (data is Map && params['msgType'] == 1) {
        setState(() {
           pageSchedulingData = data;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // 设置 设计图和设备的 宽高比例
    var _adapt = SelfAdapt.init(context);
    Widget header = DrawerHeader(
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
                    child: new Text(this._userName, style: new TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),),
                  )
                ),
              ],),
          ),
        ),
      ]),);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('我的任务', style: TextStyle(fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.transparent
      ),
      drawer: new Drawer(
        child: new Container(
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover
            )
          ),
          child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            header,  // 上面是自定义的header
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
                      child: new Text(this._departmentName,style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
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
                      child: new Text(this._phoneNum,style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
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
                      child: new Text(this._postName,style: TextStyle(color: Color(0xFFffffff),fontSize: _adapt.setFontSize(16))),
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
                        child: Icon(Icons.keyboard_arrow_right,color: Color(0xFF999999),),
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
          ],
          ),
        ),
      ),
      body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //居左
              children: <Widget>[
                Container(
                  height: _adapt.setHeight(44),
                  color: Color.fromRGBO(4, 38, 83, 0.35),
                  margin: EdgeInsets.only(top: _adapt.setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            if (msgType != 2) {
                              setState(() {
                                _work = false;
                                _shift = true;
                                msgType = 2;
                              });
                              this.getInitData();
                            }
                          },
                          child:  Text('工单处理', textAlign: TextAlign.center, style: 
                            TextStyle( 
                              color:  this._work == false ? Color.fromRGBO(74, 144, 226, 1) : Color.fromRGBO(229,229,229,1)
                              )
                            ),
                        )
                      ),
                      Expanded(
                        child: Offstage(
                          offstage: addShiftDuty || shiftDutyManage ? false : true,
                          child: GestureDetector(
                              onTap: (){
                                  if (msgType != 1) {
                                     setState(() {
                                      _work = true;
                                      _shift = false;
                                      msgType = 1;
                                    });
                                    this.getInitData();
                                  }
                              },
                              child: Center(
                                child: Text('换班处理', style: 
                                  TextStyle(
                                    color:  this._shift == false ? Color.fromRGBO(74, 144, 226, 1) : Color.fromRGBO(229,229,229,1)
                                    )
                                  ),
                              ),
                            )
                        )
                      )
                    ],
                  )
                ),
                Offstage( //工单处理
                  offstage: this._work, // 是否隐藏该子组件
                  child: Container(
                          child: Column(
                            children: <Widget>[
                              Offstage(
                                offstage: admin || keepInRepair ? false : true,
                                child: Container(
                                    height: _adapt.setHeight(72),
                                    color: Color.fromRGBO(4, 38, 83, 0.35),
                                    margin: EdgeInsets.only(top: _adapt.setHeight(10)),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Center(
                                            child: Container(
                                              width: _adapt.setWidth(80),
                                              child: FlatButton(
                                                onPressed: (){
                                                  // 管理员权限不能点击， 维修人 可以展示出来可以点击
                                                  if (admin && !keepInRepair) {
                                                      return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => WorkOrderList(workOrderType: '0')
                                                  ));
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image(
                                                      image: AssetImage('assets/images/newWorkOrder.png'),
                                                      width: _adapt.setWidth(26),
                                                      height: _adapt.setHeight(26),
                                                      // fit: BoxFit.cover,
                                                    ),
                                                    Text('新工单', style: TextStyle(color: Color.fromRGBO(171,171,171,1)),)
                                                  ],
                                                )
                                                // ,
                                              ),
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            width: _adapt.setWidth(1),
                                            height: _adapt.setHeight(44),
                                            color: Color.fromRGBO(76, 135, 179, 1),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                              child: Text(pageWorkOrderData['newWorkOrderNum'].toString(), style: TextStyle(color: Color.fromRGBO(106, 167, 255, 1), fontSize: _adapt.setFontSize(60)),),
                                            )
                                        )
                                      ],
                                    )
                                  ),
                              ),
                              Offstage(
                                offstage: !keepInRepair,
                                child: ButtonBars(title:'我的工单', number: pageWorkOrderData['workOrderNum'],callCback: (){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => WorkOrderList(userID: userId,workOrderType: "1",)
                                        ));
                                    })
                              ),
                              Offstage(
                                offstage: !repair,
                                child: ButtonBars(title:'我的报修', number:  pageWorkOrderData['repairNum'], callCback: (){
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => WorkOrderList(userID: userId,workOrderType: "2",)
                                          ));
                                        })
                              ),
                              Offstage(
                                offstage: !admin,
                                child: ButtonBars(title:'退单处理', number: pageWorkOrderData['drawBackNum'],callCback: (){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => WorkOrderList(userID: userId,workOrderType: "3",)
                                        ));
                                      }),
                              ),
                              Offstage(
                                offstage: !admin,
                                child: ButtonBars(title:'挂起工单', number: pageWorkOrderData['hangWorkOrderNum'], callCback: (){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => WorkOrderList(workOrderType: "4")
                                        ));
                                      }),
                              )
                            ],
                          ),
                        ),
                ),
                Offstage( //换班处理
                  offstage: this._shift, // 是否隐藏该子组件
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Offstage(
                          offstage: !shiftDutyManage,
                          child: Column(
                            children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: _adapt.setWidth(15), top: _adapt.setHeight(20), bottom: _adapt.setHeight(10)),
                                  child: Text('管理端', style: TextStyle(color: Color.fromRGBO(224, 224, 224, 1), fontSize: _adapt.setFontSize(15)),),
                                ),
                                ButtonBars(title:'待审批', number:  pageSchedulingData['beforeApproval'], callCback: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ApprovalPendingList(type: '2', title: '待审批')
                                      ));
                                }),
                                ButtonBars(title:'已审批', number:  pageSchedulingData['afterApproval'], callCback: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Approved(type: '1')
                                      ));
                                }),
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: !addShiftDuty,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: _adapt.setWidth(15), top: _adapt.setHeight(20), bottom: _adapt.setHeight(10)),
                                  child: Text('普通端', style: TextStyle(color: Color.fromRGBO(224, 224, 224, 1), fontSize: _adapt.setFontSize(15)),),
                                ),
                                ButtonBars(title:'换班申请', number: 0, callCback: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AddShiftDuty()
                                    ));
                                }),
                                ButtonBars(title:'我的处理', number:  pageSchedulingData['myApproval'], callCback: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ApprovalPendingList(type: '3', title: '我的处理')
                                      ));
                                }),
                                ButtonBars(title:'审批中', number:  pageSchedulingData['inApproval'], callCback: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => InApproval(type: '5')
                                      ));
                                }),
                                ButtonBars(title:'已审批', number:  pageSchedulingData['ordinaryApproval'], callCback: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Approved(type: '4')
                                      ));
                                }),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                )
            ]
          )
        ),
    );
  }
}
