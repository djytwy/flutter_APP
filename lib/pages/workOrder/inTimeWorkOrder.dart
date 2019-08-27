import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/workOrderItems.dart';
import '../../services/pageHttpInterface/InTimeWorkOrder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/src/material/dialog.dart' as Dialog;
import 'dart:convert';

// class PickText extends StatelessWidget {
//   PickText({
//     Key key,
//     this.context
//     }) : super(key: key);
//   final context;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FlatButton(
//         child: Text('data3'),
//         onPressed: (){
//           showPicker(context, gradeString);
//         },
//       ),
//     );
//   }
// }


class InTimeWorkOrder extends StatefulWidget {
  InTimeWorkOrder({Key key, this.orderID}) : super(key: key);
  final orderID;

  _InTimeWorkOrderState createState() => _InTimeWorkOrderState();
}

class _InTimeWorkOrderState extends State<InTimeWorkOrder> {
  EasyRefreshController _controller; // 下拉组件
  Map warningMap = { 1:'低', 2:'中' ,3:'高'};   // 紧急程度
  List statusList = ['处理中', '新建' ,'已完成', '待验收', '退单中', '无法处理', '挂起'];   // 任务状态列表   

  int _pageNow = 1;   // 当前页码
  List listData = []; // 接口返回的list数据  

  int _count = 0;  // 消息数量  

  String choiceClick='工单进度'; // 工单进度、工单概况的按钮  

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  // 全局的Scoffold的key

  String itemsString = '''["全部状态","处理中","已完成","待验收","退回中","无法处理","挂起"]'''; 
  String floorString = '''["1","2","3","4","5","6","7","8","9"]''';
  String gradeString = '''["高","中","低"]''';

  String result;                                  

  @override
  void initState(){
    super.initState();
    _getData();
    _controller = EasyRefreshController();
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

  void _getData(){
    // getData(_pageNow).then((data) {
    //   if(data['total'] <= _count) {
    //     _overLoad();
    //   } else {
    //     setState(() {
    //       listData += data["data"];
    //       _count += data["data"].length;
    //     });
    //   }
    // });
  }

  void _refreshData() {
    // getData(1).then((data) {
    //   setState(() {
    //     listData = data["data"];
    //     _count = data["data"].length;
    //   });
    // });
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
            child: Text('即时工单',style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)))
          ),
          actions: <Widget>[
            // 时间组件占位
            Container(
              width: ScreenUtil.getInstance().setWidth(120),
              child: Text('')
            ),
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
                        onPressed: (){
                          setState(() {
                            choiceClick = '工单进度';
                          });
                          print('工单进度');
                        },
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        textColor: choiceClick == '工单概况'? Colors.lightBlue : Colors.white70,
                        child: Text('工单概况'),
                        onPressed: (){
                          setState(() {
                            choiceClick = '工单概况';
                          });
                          print('工单概况');
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
                              child: Text('全部状态', style: TextStyle(color: Colors.white70)),
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
                              child: Text('全部楼层', style: TextStyle(color: Colors.white70)),
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
                              child: Text('全部优先级', style: TextStyle(color: Colors.white70)),
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
                      return WorkOrderItem(
                        waringMsg:warningMap[listData[index]["priority"]],
                        content: listData[index]["taskContent"],
                        fontSize: fontSize,
                        place: listData[index].containsKey("areaName") ? listData[index]["areaName"]: '无',
                        status: statusList[listData[index]["taskNowState"]],
                        time: _converTime(listData[index]["addTime"]),
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

  showPicker(BuildContext context, String itemsString) {
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
        print(value.toString());                 // 选择的数组的位置
        print(picker.getSelectedValues());       // 选择的数据
        String result = '';
        for (var index in picker.getSelectedValues()) {
          result += index;
        }
        // _pickerCallback(result, value);
        setState(() {
          result = result;
        });
      }
    );
    picker.show(_scaffoldKey.currentState);
  }

  Future _onload() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _pageNow += 1;
      });
      _getData();
    });
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _refreshData();
    });
  }
}