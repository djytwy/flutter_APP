/**
 * 即时工单页面
 *  参数：
 *    taskType :0 -> 即时工单
                1 -> 巡检工单
                2 -> 维保工单
                3 -> 系统工单
   Update: 2019-11-14
   author: twy
 *
 * */

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/workOrderItems.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './view/PrivateDatePrick.dart';
import 'dart:convert';
import './workOrderSurvey.dart';
import '../../services/pageHttpInterface/inTimeWorkOrder.dart';
import '../../utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 抽屉页
import './view/drawPage.dart';

/*
  taskType :0 -> 即时工单
            1 -> 巡检工单
            2 -> 维保工单
            3 -> 系统工单
*/

class InTimeWorkOrder extends StatefulWidget {
  InTimeWorkOrder({
    Key key, 
    this.taskType
  }) : super(key: key);
  final taskType;  // 任务类型 (即时工单不显示完成时限)

  _InTimeWorkOrderState createState() => _InTimeWorkOrderState();
}

class _InTimeWorkOrderState extends State<InTimeWorkOrder> {
  final listType = {      // 枚举列表的类型（上拉加载，下拉刷新，其他都是重置）
    'refresh': '0',
    'reset': '1',
    'append': '2'
  };
  Map<String,dynamic> serverData;
  EasyRefreshController _controller; // 下拉组件
  Map warningMap = { 1:'低', 2:'中' ,3:'高', };   // 紧急程度
  List statusList = ['处理中', '新建' ,'已完成', '待验收', '退单中', '无法处理', '挂起'];   // 任务状态列表   

  int flag = -1;
  dynamic taskState = "";
  dynamic priority = "";   // 优先级
  String userId;       // 用户Id
  int _pageNow = 1;    // 当前页码
  List listData = [];  // 接口返回的list数据  

  int _count = 0;  // 消息数量
  dynamic msgData; // 及时工单未读

  String choiceClick='工单进度'; // 工单进度、工单概况的按钮  

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  // 全局的Scoffold的key

  String itemsString = '''["全部状态","新建","处理中","已完成","待验收","退单中","无法处理","挂起"]''';
  String floorString = '''[
    {"一楼拐角处":[{"这是一楼":[1,2,3]},{"这是二楼":[""]}]},
    {"二楼拐角处":[{"这是一一楼":[14,63,35]},{"这是二二楼":[144,243,223]}]}
  ]''';
  Object placeIdList;   // 楼层的ID
  String gradeString = '''["全部优先级","高","中","低"]''';  // 工单的优先级

  String result;     // 选择查询条件的结果
  String items = '全部状态';
  String floor = '全部楼层';
  String grade = '全部优先级';   

  bool showExtime = false;    // 即时工单不显示完成时限
  String dateString;  // 时间字符串                    
  // 默认 无权限
  bool admin = false; //管理员
  bool repair = false; // 报修
  bool keepInRepair = false; //维修
  String _totalNum = '0'; // 所有的及时工单数量
  dynamic keyWord = false;  // 关键字
  dynamic delay = false; // 是否延时

  @override
  void didUpdateWidget(InTimeWorkOrder oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // 注释消息未读已读的代码
//    var params = {
//      'userId': userId,
//      'submodelId': 2,
//      'msgIsread': 0,
//      'msgType': 2,
//      'msgStatus': 106
//    };
//    getAllWorksStatus(params).then((data){
//      setState(() {
//        msgData = data;
//      });
//    });
  }

  @override
  void initState() {
    super.initState();
    initAuth().then((_val) {
      setState(() {
        dateString = getCurrentTime(timeParams: 2);
      });
      getData().then((val) {
        List list = [];
        list.add({"全部楼层":[{"":[""]}]});
        val.forEach((item){
          list.add(item);
        });
        setState(() {
          floorString = json.encode(list);
        });
      });
      getPlaceID().then((val) {
        setState(() {
          placeIdList = val;
        });
      });
      _controller = EasyRefreshController();
      _getInitParams(widget.taskType,userId,flag,_pageNow,taskState,priority);
      if(widget.taskType.toString() != "0")
        setState(() {
          showExtime = true;
        });
    });
  }

    // 初始化权限(因为是异步操作所以return一个null用于判断操作是否结束)
  initAuth() async {
    Map auth = await getAllAuths();
    setState(() {
      admin = auth['admin'];
      repair = auth['repair'];
      keepInRepair = auth['keepInRepair'];
    });
    return null;
  }
  // 上拉加载更多的提示
  void _overLoad(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      // backgroundColor: Colors.greenAccent,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM
    );
  }
  // 获取初始信息
  void _getInitParams(taskType,userId,flag,pageNum,taskState,priority) async {
    SharedPreferences prefe = await SharedPreferences.getInstance();
    if (prefe.getString('authMenus').indexOf('50') != -1) {
      // 管理人员为 1
      setState(() {
        flag = 1;
      });
      this.flag = 1;
    } else if (repair == true && admin == false && keepInRepair == false) {
      // 报修为2
      setState(() {
        flag = 2;
      });
      this.flag = 2;
    } else {
      // 普通为 -1
      setState(() {
        flag = -1;
      });
      this.flag = -1;
    }
    String _userId = await getLocalStorage('userId');
    setState(() {
      userId = _userId;
    });
    this.userId = _userId;
    await _getData(taskType,userId,flag,pageNum,taskState,priority,listType['reset'],keyWord,delay);
  }
  // 查询工单并渲染工单数据
  Future _getData(
    taskType,
    userId,
    flag,
    pageNum,
    taskState,
    priority,
    listType,
    keyWord,
    delay
    ) async {
    // 这里把dateString时间加上
    Map<String, dynamic> _data = await getOrderData(
      taskType,
      userId,
      flag,
      pageNum,
      taskState,
      priority,
      dateString,
      keyWord,
      delay
    );
    if(_data.containsKey('mainInfo')) {
      setState(() {
        serverData = _data['mainInfo'];
      });
      // 获得数据了之后再进行渲染
      renderData(listType);
    } else {
      showTotast('数据错误！');
    }
  }

  // 点击筛选的逻辑
  void _filter(ctx) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => DrawPage()))
      .then((arg) async {
        if(arg == null || arg.length == 0 || arg["optionFlag"] == false) return ;
        final gradeMap = {"全部优先级": "", "高优先级": "3","中优先级":"2","低优先级":"1"};
        final stateMap = {
          "全部状态": "",
          "处理中": "0",
          "已完成": "2",
          "待验收": "3",
          "退单中": "4",
          "无法处理": "5",
          "挂起": "6",
          "新建": "1",
        };
        final delayMap = {"全部":"-1","是":"2","否":"0"};
        dynamic stateList = arg["state"] != null ? arg["state"].map((e){
          return stateMap[e];
        }) : "";
        dynamic gradeList = arg["grade"] != null ? arg["grade"].map((e){
          return gradeMap[e];
        }) : "";
        dynamic delayList = arg["delay"] != null ? arg["delay"].map((e){
          return delayMap[e];
        }) : "-1";
        // 赋值新的工单状态、优先级、是否延时
        setState(() {
          taskState = stateList == "" ? "" : stateList.toList().join(",");
          priority = gradeList == "" ? "" : gradeList.toList().join(",");
          delay = delayList == "-1"? "-1" : delayList.toList().join(",");
        });
        await _getData(
          widget.taskType,userId,flag,_pageNow,
          taskState,
          priority,
          listType['reset'],keyWord,
          delay
        );
      });
  }

  // 根据页面选择渲染数据
  void renderData(_listType) {
    if(_listType == listType['reset'] || _listType == listType['refresh']) {
      setState(() {
        listData = serverData["list"];
        _count = serverData["list"].length;
        _totalNum = serverData['total'].toString();
      });
    } else if (_listType == listType['append'] && serverData['total'] <= _count) {
      _overLoad('已经到底了');
    } else {
      setState(() {
        listData += serverData["list"];
        _count += serverData["list"].length;
        _totalNum = serverData['total'].toString();
      });
    }
  }

  // 上拉加载更多
  Future _onload() async {
    await Future.delayed(Duration(seconds: 1), () async {
      setState(() {
        _pageNow += 1;
      });
      await _getData(widget.taskType,userId,flag,_pageNow,taskState,priority,listType['append'],keyWord,delay);
    });
  }

  // 下拉刷新
  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () async {
      dynamic _userId = await getLocalStorage('userId');
      setState(() {
        userId = _userId;
      });
      await _getData(widget.taskType,userId,flag,1,taskState,priority,listType['refresh'],keyWord, delay);
    });
  }

  // 转换时间格式
  String _convertTime(time) {
    DateTime _time = DateTime.parse(time);
    final nowDay = DateTime.now();
    final yesterday = nowDay.subtract(Duration(days: 1));
    int hour = _time.hour;
    int minute = _time.minute;
    if (_time.day == nowDay.day && _time.month == nowDay.month && _time.year == nowDay.year) {
      return '${addZero(hour)}:${addZero(minute)}';
    } else if (_time.day == yesterday.day && _time.month == yesterday.month && _time.year == yesterday.year) {
      return '昨天 ${addZero(hour)}:${addZero(minute)}';
    } else 
      return time;
  }

  // 根据时间获取工单列表信息
  Future<void> _getDataByTime(_dateString) async {
    setState(() {
      _pageNow = 1;
      dateString = _dateString;
    });
    await _getData(widget.taskType,userId,flag,_pageNow,taskState,priority,listType['reset'],keyWord,delay);
  }

  // 搜索关键字
  void _searchKey(_keyWord) async {
    setState(() {
      keyWord = _keyWord;
    });
    await _getData(widget.taskType,userId,flag,1,taskState,priority, listType['reset'],keyWord,delay);
  }

  @override
  Widget build(BuildContext context) {
    // 设置 设计图和设备的 宽高比例
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    double fontSize = ScreenUtil.getInstance().setSp(30);   // 默认字体大小
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        endDrawer: Container(),
        appBar: AppBar(
          backgroundColor: Colors.transparent, 
          centerTitle: true,
          title: Center(
            child: Text(
              widget.taskType == '0' ? '即时工单' : widget.taskType == '1' ? '巡检工单' : widget.taskType == '2'? '维保工单' : widget.taskType == '3' ? '系统工单' : '',
              style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)))
          ),
          actions: <Widget>[
            // 时间组件占位
            PrivateDatePrick(change: _getDataByTime)
          ],
        ),

        body: Center(
          child: Column(
            children: <Widget>[
              // 搜索框
              Container(
                padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(30)),
                width: ScreenUtil.getInstance().setWidth(720),
                child: TextField(
                  style: TextStyle(color: Colors.white54),
                  onChanged: _searchKey,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    hintText: '请输入关键词',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Color(0x60000000),
                    suffixIcon: Icon(Icons.search,color: Colors.blue),
                  ),
                ),
              ),
              // 工单进度、工单概况的tab
              Container(
                margin: EdgeInsets.fromLTRB(
                  0.0,
                  ScreenUtil.getInstance().setHeight(10),
                  0.0,
                  ScreenUtil.getInstance().setHeight(5),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 12, 33, 53),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        textColor: choiceClick == '工单进度'? Colors.lightBlue : Colors.white70,
                        child: Text('工单进度'),
                        onPressed: (){},
                      ),
                    ),
                    Expanded(
                      child: Offstage(
                        offstage: !admin,
                        child: FlatButton(
                          textColor: choiceClick == '工单概况'? Colors.lightBlue : Colors.white70,
                          child: Text('工单概况'),
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => WorkOrderSurvey(taskType: widget.taskType)
                            ));
                          },
                        ),
                      ),
                    )
                  ]
                ),
              ),
              // 总共的工单数量
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('共 $_totalNum 单', style: TextStyle(color: Colors.white60,fontSize: ScreenUtil.getInstance().setSp(20))),
                      ),
                    ),
                    Expanded(
                      child:  GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text('筛选',style: TextStyle(color: Colors.white54)),
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(IconData(0xe612,fontFamily: 'aliFonts'),color: Colors.blue)
                              )
                            )
                          ],
                        ),
                        onTap: (){_filter(context);},
                      )
                    )
                  ],
                )
              ),
              // 列表items
              Expanded(
                child: EasyRefresh(
                  onLoad: _onload,
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: _count,
                    itemBuilder: (context, index) {
                      // listData2 用于转换地点避免报错
                      var listData2 = listData;
                      return WorkOrderItem(
//                        redPoint: ,
                        waringMsg:warningMap[listData[index]["priority"]],
                        content: listData[index]["taskContent"],
                        fontSize: fontSize,
                        place: listData2[index].containsKey("areaName") ? listData[index]["areaName"]:'无',
                        status: statusList[listData[index]["taskState"]],
                        time: _convertTime(listData[index]["addTime"]),
                        orderID: listData[index]["ID"],
                        showExtime: showExtime,
                      );
                    },
                  ),
                ),
              ),
            ],
          ), 
        ),
      )
    );
  }
}
