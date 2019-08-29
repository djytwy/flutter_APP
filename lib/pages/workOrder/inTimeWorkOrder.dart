import 'package:app_tims_hotel/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/workOrderItems.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/src/material/dialog.dart' as Dialog;
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
  int paceId = -1;
  int priority = -1;   // 优先级
  String userId;
  int _pageNow = 1;   // 当前页码
  List listData = []; // 接口返回的list数据  

  int _count = 0;  // 消息数量  

  String choiceClick='工单进度'; // 工单进度、工单概况的按钮  

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  // 全局的Scoffold的key

  String itemsString = '''["全部状态","处理中","已完成","待验收","退回中","无法处理","挂起"]'''; 
  // String floorString = '''["1","2","3","4","5","6","7","8","9"]''';
  String floorString = '''[
    {"一楼拐角处":[{"这是一楼":[1,2,3]},{"这是二楼":[""]}]},
    {"二楼拐角处":[{"这是一一楼":[14,63,35]},{"这是二二楼":[144,243,223]}]}
  ]''';
  Object placeIdList;   
  String gradeString = '''["全部优先级","高","中","低"]''';

  String result;     
  String items = '全部状态';
  String floor = '全部楼层';
  String grade = '全部优先级';   

  bool showExtime = false;    // 及时工单不显示完成时限 
  String dateString;  // 时间字符串                    

  @override
  void initState(){
    super.initState();
    getData().then((val) {
      setState(() {
        floorString = json.encode(val);
      });
    });
    getPlaceID().then((val) {
      setState(() {
        placeIdList = val;
      });
    });
    _controller = EasyRefreshController();
    _getInitParams(widget.taskType,userId,flag,_pageNow,taskState,paceId,priority);
    if(widget.taskType.toString() != "0") 
    setState(() {
      showExtime = true;
    });
  }

  void _overLoad() {
    Fluttertoast.showToast(
      msg: "已经到底了",
      toastLength: Toast.LENGTH_SHORT,
      // backgroundColor: Colors.greenAccent,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM
    );
  }
  void _getInitParams(taskType,userId,flag,pageNum,taskState,paceId,priority) async{
    SharedPreferences prefe = await SharedPreferences.getInstance();
    if (prefe.getString('authMenus').indexOf('50') != -1) {
      setState(() {
        flag = 1;
      });
    }
    getLocalStorage('userId').then((val) {
      setState(() {
        userId = val;
      }); 
      _getData(taskType,userId,flag,pageNum,taskState,paceId,priority);
    });
  }
  void _getData(taskType,userId,flag,pageNum,taskState,paceId,priority){
    getOrderData(taskType,userId,flag,pageNum,taskState,paceId,priority).then((data) {
      setState(() {
        listData = data['mainInfo']["list"];
        _count = data['mainInfo']["list"].length;
      });
    });
  }

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
        }
        _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
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
          title: Center(
            child: Text(
              widget.taskType == '0' ? '即时工单' : widget.taskType == '1' ? '巡检工单' : '维保工单',
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
                      child: FlatButton(
                        textColor: choiceClick == '工单概况'? Colors.lightBlue : Colors.white70,
                        child: Text('工单概况'),
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => WorkOrderSurvey(taskType: widget.taskType)
                            ));
                        },
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
    // 月、日若是一个数则前面加0
    List _dateList = dateString.split("-");
    String _dateString = "";
    for(var item in _dateList) {
      if(item.length < 2) _dateString = _dateString + "-0" + item;
      else if (item.length > 3) _dateString += item;
      else _dateString = _dateString + "-"+item;
    }

    setState(() {
      dateString = _dateString;
    });

    final userId = await getLocalStorage('userId');
    final _data = await getOrderData(widget.taskType,userId,flag,_pageNow,taskState,paceId,priority,_dateString);
    setState(() {
      listData = _data['mainInfo']["list"];
      _count = _data['mainInfo']["list"].length;
    });
  }

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
            paceId = temp is Map? int.parse(temp.keys.toList()[0]): int.parse(temp);
            floor = rest;
          });
        } else if (itemString == gradeString) {
          setState(() {
            grade = rest;
          });
        }
        // _pickerCallback(result, value);
        setState(() {
          result = rest;
        });
        print(paceId);
        print(result);
        print('/////////////////////////////////');
        if (result == '全部状态') {
          setState(() {
            taskState = -1;
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '处理中') {
          setState(() {
            taskState = 0;
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '已完成') {
          setState(() {
            taskState = 2; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '待验收') {
          setState(() {
            taskState = 3; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '退回中') {
          setState(() {
            taskState = 4; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '无法处理') {
          setState(() {
            taskState = 5; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '挂起') {
          setState(() {
            taskState = 6; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '全部优先级') {
          setState(() {
            priority = -1; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '高') {
          setState(() {
            priority = 3; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '中') {
          setState(() {
            priority = 2; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else if (result == '低') {
          setState(() {
            priority = 1; 
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
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        } else {
          getLocalStorage('userId').then((val) {
            setState(() {
              userId = val;
            });
            getLocalStorage('authMenus').then((val) {
              if (val.toString().indexOf('50') != -1) {
                setState(() {
                  flag = 1;
                });
              }
              _getData(widget.taskType,userId,flag,1,taskState,paceId,priority);
            });
          });
        }
      }
    );
    picker.show(_scaffoldKey.currentState);
  }

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
          }
          getOrderData(widget.taskType,userId,flag,_pageNow,taskState,paceId,priority).then((data) {
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