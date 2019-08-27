import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/workOrderItems.dart';
import '../../services/pageHttpInterface/myOrder.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyOrder extends StatefulWidget {
  MyOrder({Key key, this.orderID}) : super(key: key);
  final orderID;

  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  EasyRefreshController _controller; // 下拉组件
  Map warningMap = { 1:'低', 2:'中' ,3:'高'};   // 紧急程度
  List statusList = ['处理中', '新建' ,'已完成', '待验收', '退单中', '无法处理', '挂起'];   // 任务状态列表   

  int _pageNow = 1;   // 当前页码
  List listData = []; // 接口返回的list数据  
  int _count = 0;  // 消息数量                                        

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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent, 
          title: Center(
            child: Text('我的工单',style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)))
          ),
          actions: <Widget>[
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
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(10),
                child: Text('共 $_count 单', style: TextStyle(color: Colors.white60,fontSize: ScreenUtil.getInstance().setSp(20)))      
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