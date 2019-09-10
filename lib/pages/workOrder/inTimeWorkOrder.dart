import 'package:app_tims_hotel/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/workOrderItems.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_picker/flutter_picker.dart';
import './view/PrivateDatePrick.dart';
import 'dart:convert';
import './workOrderSurvey.dart';
import '../../services/pageHttpInterface/inTimeWorkOrder.dart';
import '../../utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  taskType :0 -> 及时工单
            1 -> 巡检工单
            2 -> 维保工单
*/

class InTimeWorkOrder extends StatefulWidget {
  InTimeWorkOrder({
    Key key, 
    this.taskType
  }) : super(key: key);
  final taskType;  // 任务类型 (及时工单不显示完成时限)

  _InTimeWorkOrderState createState() => _InTimeWorkOrderState();
}

class _InTimeWorkOrderState extends State<InTimeWorkOrder> {
  EasyRefreshController _controller; // 下拉组件
  Map warningMap = { 1:'低', 2:'中' ,3:'高', };   // 紧急程度
  List statusList = ['处理中', '新建' ,'已完成', '待验收', '退单中', '无法处理', '挂起'];   // 任务状态列表   
  int flag = -1;
  int taskState = -1;
  int placeId = -1;
  int priority = -1;   // 优先级
  String userId;       // 用户Id
  int _pageNow = 1;    // 当前页码
  List listData = [];  // 接口返回的list数据  

  int _count = 0;  // 消息数量  

  String choiceClick='工单进度'; // 工单进度、工单概况的按钮  

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  // 全局的Scoffold的key

  String itemsString = '''["全部状态","处理中","已完成","待验收","退回中","无法处理","挂起"]'''; 
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

  bool showExtime = false;    // 及时工单不显示完成时限 
  String dateString;  // 时间字符串                    
  // 默认 无权限
  bool admin = false; //管理员
  bool repair = false; // 报修
  bool keepInRepair = false; //维修
  @override
  void initState(){
    super.initState();
    initAuth();
    setState(() {
      dateString = getCurrentDay();
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
      print('=========================');
      print(placeIdList);
    });
    _controller = EasyRefreshController();
    _getInitParams(widget.taskType,userId,flag,_pageNow,taskState,placeId,priority);
    if(widget.taskType.toString() != "0") 
    setState(() {
      showExtime = true;
    });
  }
    // 初始化权限
  initAuth() async{
    Map auth = await getAllAuths();
    setState(() {
      admin = auth['admin'];
      repair = auth['repair'];
      keepInRepair = auth['keepInRepair'];
    });
    
  }
  // 上拉加载更多的提示
  void _overLoad() {
    Fluttertoast.showToast(
      msg: "已经到底了",
      toastLength: Toast.LENGTH_SHORT,
      // backgroundColor: Colors.greenAccent,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM
    );
  }
  // 获取初始信息
  void _getInitParams(taskType,userId,flag,pageNum,taskState,placeId,priority) async{
    SharedPreferences prefe = await SharedPreferences.getInstance();
    if (prefe.getString('authMenus').indexOf('50') != -1) {
      setState(() {
        flag = 1;
      });
    } else if (repair == true && admin == false && keepInRepair == false) {
      setState(() {
        flag = 2;
      });
    }
    getLocalStorage('userId').then((val) {
      setState(() {
        userId = val;
      }); 
      _getData(taskType,userId,flag,pageNum,taskState,placeId,priority);
    });
  }
  // 查询工单
  void _getData(taskType,userId,flag,pageNum,taskState,placeId,priority){
    print('------------------------------');
    print(placeId);
    getOrderData(taskType,userId,flag,pageNum,taskState,placeId,priority, dateString).then((data) {
      setState(() {
        listData = data['mainInfo']["list"];
        _count = data['mainInfo']["list"].length;
      });
    });
  }
  // 下拉刷新
  void _refreshData() {
    getLocalStorage('userId').then((val) {
      setState(() {
        userId = val;
      }); 
      getLocalStorage('authMenus').then((val) {
        if(val.toString().indexOf('50') != -1) {
          setState(() {
            flag = 1;
          });
        } else if (repair == true && admin == false && keepInRepair == false) {
          setState(() {
            flag = 2;
          });
        }
        _getData(widget.taskType,userId,flag,1,taskState,placeId,priority);
      });
    });
  }

  String _converTime(time){
    DateTime _time = DateTime.parse(time);
    final nowDay = DateTime.now();
    final yesterday = nowDay.subtract(Duration(days: 1));
    int hour = _time.hour;
    int seconds = _time.second;
    if (_time.day == nowDay.day && _time.month == nowDay.month && _time.year == nowDay.year) {
      return '$hour:$seconds';
    } else if (_time.day == yesterday.day && _time.month == yesterday.month && _time.year == yesterday.year) {
      return '昨天 $hour:$seconds';
    } else 
      return time;
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
        appBar: AppBar(
          backgroundColor: Colors.transparent, 
          centerTitle: true,
          title: Center(
            child: Text(
              widget.taskType == '0' ? '即时工单' : widget.taskType == '1' ? '巡检工单' : widget.taskType == '2'? '维保工单' : '',
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
                  ]),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Center(
                            child: FlatButton(
                              child: Text(this.items, style: TextStyle(color: Colors.white70)),
                              onPressed: (){
                                showPicker(context, itemsString);
                              },
                            ),
                          ),
                          Expanded(
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.lightBlue,
                            ),
                          )
                        ],
                      ) 
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Center(
                            child: FlatButton(
                              child: Container(
                                width: setWidth(120),
                                child: Text(this.floor, 
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white70)),
                              ),
                              onPressed: (){
                                showPicker(context, floorString);
                              },
                            ),
                          ),
                          Expanded(
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.lightBlue,
                            ),
                          )
                        ],
                      ) 
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Center(
                            child: FlatButton(
                              child: Text(this.grade, style: TextStyle(color: Colors.white70)),
                              onPressed: (){
                                showPicker(context, gradeString);
                              },
                            ),
                          ),
                          Expanded(
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.lightBlue,
                            ),
                          )
                        ],
                      ) 
                    )
                  ],
                ),
                margin: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(10)),
              ),
              Expanded(
                child: EasyRefresh(
                  onLoad: _onload,
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: _count,
                    itemBuilder: (context, index) {
                      var listData2 = listData;
                      return WorkOrderItem(
                        waringMsg:warningMap[listData[index]["priority"]],
                        content: listData[index]["taskContent"],
                        fontSize: fontSize,
                        place: listData2[index].containsKey("areaName") ? listData[index]["areaName"]: '无',
                        status: statusList[listData[index]["taskState"]],
                        time: _converTime(listData[index]["addTime"]),
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

  void _getDataByTime(dateString) async {
    setState(() {
      _pageNow = 1;
    });
    setState(() {
      dateString = dateString;
    });

    final userId = await getLocalStorage('userId');
    final _data = await getOrderData(widget.taskType,userId,flag,_pageNow,taskState,placeId,priority, dateString);
    setState(() {
      listData = _data['mainInfo']["list"];
      _count = _data['mainInfo']["list"].length;
    });
  }
  // 显示筛选条件的弹窗
  showPicker(BuildContext context, String itemString) {
    Picker picker = Picker(
      adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(itemString)),
      changeToFirst: true,
      textAlign: TextAlign.center,
      textStyle: const TextStyle(color: Colors.blue),
      selectedTextStyle: TextStyle(color: Colors.red),
      columnPadding: const EdgeInsets.all(8.0),
      cancelText:'取消',
      confirmText: '确定',

      onConfirm: (Picker picker, List value) {
        print(value.toString());                 // 选择的数组的位置
        print(picker.getSelectedValues());       // 选择的数据
        String rest = '';
        for (var index in picker.getSelectedValues()) {
          rest += index;
        }
        print(JsonDecoder().convert(itemsString));
        if (itemString == itemsString) {
          setState(() {
            items = rest;
          });
        } else if (itemString == floorString){
        if (rest == '全部楼层') {
          setState(() {
            placeId = -1;
            floor = rest;
          });
        } else {
          dynamic temp = placeIdList;
          if(value == [0,0,0]) {
            // 全部楼层
          } else {
            value[0] -= 1;
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
          }
          setState(() {
            placeId = temp is Map? int.parse(temp.keys.toList()[0]): int.parse(temp);
            floor = rest;
          });
        }
 
        } else if (itemString == gradeString) {
          setState(() {
            grade = rest;
          });
        }
        setState(() {
          result = rest;
        });
        if (result == '全部状态') {
          setState(() {
            taskState = -1;
          });
          _diffAuth();
        } else if (result == '处理中') {
          setState(() {
            taskState = 0;
          });
          _diffAuth();
        } else if (result == '已完成') {
          setState(() {
            taskState = 2; 
          });
          _diffAuth();
        } else if (result == '待验收') {
          setState(() {
            taskState = 3; 
          });
          _diffAuth();
        } else if (result == '退回中') {
          setState(() {
            taskState = 4; 
          });
          _diffAuth();
        } else if (result == '无法处理') {
          setState(() {
            taskState = 5; 
          });
          _diffAuth();
        } else if (result == '挂起') {
          setState(() {
            taskState = 6; 
          });
          _diffAuth();
        } else if (result == '全部优先级') {
          setState(() {
            priority = -1; 
          });
          _diffAuth();
        } else if (result == '高') {
          setState(() {
            priority = 3; 
          });
          _diffAuth();
        } else if (result == '中') {
          setState(() {
            priority = 2; 
          });
          _diffAuth();
        } else if (result == '低') {
          setState(() {
            priority = 1; 
          });
          _diffAuth();
        } else {
          _diffAuth();
        }
      }
    );
    picker.show(_scaffoldKey.currentState);
  }
  // 根据筛选条件查询工单
  Future _diffAuth() async {
    getLocalStorage('userId').then((val) {
      setState(() {
        userId = val;
      });
      getLocalStorage('authMenus').then((val) {
        if (val.toString().indexOf('50') != -1) {
          setState(() {
            flag = 1;
          });
        } else if (repair == true && admin == false && keepInRepair == false) {
          setState(() {
            flag = 2;
          });
        }
        _getData(widget.taskType,userId,flag,1,taskState,placeId,priority);
      });
    });
  }
  // 上拉加载更多
  Future _onload() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _pageNow += 1;
      });
      getLocalStorage('userId').then((val) {
        setState(() {
          userId = val;
        });
        getLocalStorage('authMenus').then((val) {
          if (val.toString().indexOf('50') != -1) {
            setState(() {
              flag = 1;
            });
          } else if (repair == true && admin == false && keepInRepair == false) {
            setState(() {
              flag = 2;
            });
          }
          getOrderData(widget.taskType,userId,flag,_pageNow,taskState,placeId,priority, dateString).then((data) {
            if (data['mainInfo']['total'] <= _count) {
              _overLoad();
            } else {
              setState(() {
                listData += data['mainInfo']["list"];
                _count += data['mainInfo']["list"].length;
              });
            }
          });
        });
      });
    });
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _refreshData();
    });
  }
}