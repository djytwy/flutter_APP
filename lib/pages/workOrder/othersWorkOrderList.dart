// 其他人的工单
import 'package:app_tims_hotel/pages/home/scheduling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../services/pageHttpInterface/MyTask.dart';
import '../../utils/util.dart';
import 'dart:convert';
// 第三方组件
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

// 私有组件
import './view/PrivateDatePrick.dart';
import '../../components/workOrderItems.dart';

class OthersWorkOrderList extends StatefulWidget {
  OthersWorkOrderList({Key key, this.taskType, this.userId, this.userName}) : super(key: key);
  final taskType;
  final userId;
  final String userName;
  @override
  _OthersWorkOrderList createState() => _OthersWorkOrderList();
}
class _OthersWorkOrderList extends State<OthersWorkOrderList> {
  ScrollController _controller = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  // 全局的Scoffold的key
  Map warningMap = { 1:'低', 2:'中' ,3:'高'};   // 紧急程度
  List statusList = ['处理中', '新建' ,'已完成', '待验收', '退单中', '无法处理', '挂起'];   // 任务状态列表 
  String itemsString = '''["全部状态","处理中","已完成","待验收","退回中","无法处理","挂起"]''';  
  Map pickData = {
      '全部状态': null,
      '处理中': 0,
      '已完成': 2,
      '待验收': 3,
      '退回中': 4,
      '无法处理': 5,
      '挂起': 6
  };
  List pageData = []; //页面数据
  int total = 0; //总个数
  String dateString; //日期字符串
  int pageNum = 1; // 页码
  int pageSize = 10; //每页数量
  int taskState; //状态
  String status = '全部状态';// 状态
  String userName = '';
  bool floatingIsShow = false; //悬浮按钮是否展示
  @override
  void initState(){
    super.initState();
    setState(() {
      userName = widget.userName;
    });
    getPageData();
  }
  // 初始化 获取数据
  void getPageData(){
    var data = {
      'userId': widget.userId,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'taskType': widget.taskType == null ? 0 : widget.taskType, //任务类型 0 及时工单 1巡检 2维保
    };
    if (pageNum > 1 && total < pageNum * pageSize) {
      pageNum -=1;
      showTotast('没有更多数据', 'bottom');
      return;
    }
    if (dateString != null) {
      data['dateString'] = dateString;
    }
    if (taskState != null) {
      data['taskState'] = taskState;
    }
    // 工单概况
    getOneUserTaskList({'factor': json.encode(data)}).then((data){
      if(data is Map) {
        List list = [];
        if (pageNum == 1) {
          list = data['list'];
        }else if(pageNum > 1){
          list = [...this.pageData, ...data['list']];
        }
        setState(() {
          pageData = list;
          total = data['total'];
        });
      }
    });
  }
  // 日期选择变化
  datePrickChange(value){
    setState(() {
      dateString = value;
      pageNum = 1;
    });
    this.getPageData();
  }
  // 处理时间
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
  // 分页
  Future _onload() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        pageNum += 1;
      });
      this.getPageData();
    });
  }
  // 刷新
  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        pageNum = 1;
      });
      this.getPageData();
    });
  }
  @override
  Widget build(BuildContext context) {
    var _adapt =  SelfAdapt.init(context);
    return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover
              )
            ),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent, 
                centerTitle: true,
                title: Text('$userName的工单',style: TextStyle(fontSize: _adapt.setFontSize(18))),
                actions: <Widget>[
                  // 时间组件占位
                  PrivateDatePrick(change: datePrickChange)
                ],
              ),
              floatingActionButton: Offstage(
                offstage: floatingIsShow,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(width: _adapt.setWidth(1), color: Color.fromRGBO(82, 161, 255, 1)),
                    borderRadius: BorderRadius.all(new Radius.circular(30.0))
                  ),
                  child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(6,26,68,0.3),
                        border: Border.all(width: _adapt.setWidth(3), color: Color.fromRGBO(8, 19, 31, 1)),
                        borderRadius: BorderRadius.all(new Radius.circular(28.0))
                      ),
                      child: FloatingActionButton(
                        onPressed: (){
                          _controller.animateTo(.0,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.ease
                          );
                        },
                        backgroundColor: Color.fromRGBO(6,26,68,0.3),
                        child: Icon(Icons.vertical_align_top, color: Color.fromRGBO(82, 161, 255, 1), size: _adapt.setFontSize(40)),
                    )
                  )
                ),
              ),
              body: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: _adapt.setWidth(120),
                            margin: EdgeInsets.only(left: _adapt.setWidth(15)),
                            child: FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Text(status, style: TextStyle(color: Colors.white70)),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.lightBlue,
                                    )
                                  )
                                ]
                              ),
                              onPressed: (){
                                setState(() {
                                  floatingIsShow = true;
                                });
                                showPicker(context, itemsString);
                              },
                            ),
                          ),
                          Expanded(
                            child: EasyRefresh(
                              onLoad: _onload,
                              onRefresh: _refresh,
                              child: ListView.builder(
                                controller: _controller,
                                itemCount: pageData.length,
                                itemBuilder: (context, index) {
                                  return WorkOrderItem(
                                    waringMsg: warningMap[pageData[index]["priority"]],
                                    content: pageData[index]["taskContent"],
                                    fontSize: 12,
                                    place: pageData[index]["areaName"],
                                    status: statusList[pageData[index]["taskState"]],
                                    time: _converTime(pageData[index]["addTime"]),
                                    orderID: pageData[index]["ID"],
                                    isSkip: false,
                                  );
                                }
                              )
                            )
                          )
                        ]
                      ) 
                    )
          )
        );
  }
  // 显示选择框
  void showPicker(BuildContext context, String itemsString) {
    Picker picker = Picker(
      adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(itemsString)),
      changeToFirst: true,
      textAlign: TextAlign.center,
      textStyle: const TextStyle(color: Colors.blue),
      selectedTextStyle: TextStyle(color: Colors.red),
      columnPadding: const EdgeInsets.all(8.0),
      cancelText:'取消',
      confirmText: '确定',
      onConfirm: (Picker picker, List value) {
        // print(value.toString());                 // 选择的数组的位置
        // print(picker.getSelectedValues());       // 选择的数据
        String result = '';
        for (var index in picker.getSelectedValues()) {
          result += index;
        }
        setState(() {
          status = result;
          taskState = pickData[result];
          floatingIsShow  = false;
        });
        this.getPageData();
      },
      onCancel: (){
        setState(() {
          floatingIsShow = false;
        });
      }
    );
    picker.show(_scaffoldKey.currentState);
  }
}