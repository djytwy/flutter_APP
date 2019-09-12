import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/workOrderItems.dart';
import '../../services/pageHttpInterface/workOrderList.dart';
import '../../services/pageHttpInterface/comWorkOrder.dart';      // 红点未读相关
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/util.dart';

class WorkOrderList extends StatefulWidget {
  WorkOrderList({
    Key key, 
    this.userID,
    this.workOrderType
  }) : super(key: key);
  final workOrderType;  // 返回的类型: workOrderType: 0 新工单 1 我的工单 2 我的报修 3退单处理 4 挂起
  final userID;

  _WorkOrderListState createState() => _WorkOrderListState();
}

class _WorkOrderListState extends State<WorkOrderList> {
  EasyRefreshController _controller; // 下拉组件
  Map warningMap = { 1:'低', 2:'中' ,3:'高'};   // 紧急程度
  List statusList = ['处理中', '新建' ,'已完成', '待验收', '退单中', '无法处理', '挂起'];   // 任务状态列表   

  int _pageNow = 1;   // 当前页码
  List listData = []; // 接口返回的list数据  
  int _count = 0;  // 消息数量
  List idList = [];  // 接口返回的未读消息ID的list   
  Map msgMap = {}; // 所有消息的List
  String userId;  // 获取到userId                                

  @override
  void initState() {
    super.initState();
    getLocalStorage('userId').then((val) {
      setState(() {
        userId = val;
      });
      _getData(null);
    });
    _controller = EasyRefreshController();
  }

  Future _unReadMsg() async {
    var params = {
      "msgIsread": "0",
      "msgType": "2",
      "submodelId": "2",
      "userId": userId
    };
    if (widget.workOrderType == '0') { //新工单
       params['msgStatus'] = '100';
    }else if (widget.workOrderType == '1') {// 我的工单
        params['msgStatus'] = '101';
    }else if(widget.workOrderType == '2'){// 我的报修
        params['msgStatus'] = '102';
    }else if(widget.workOrderType == '3'){//退单处理
        params['msgStatus'] = '103';
    }else if(widget.workOrderType == '4'){// 挂起
        params['msgStatus'] = '104';
    }
    final val = await unReadMsg(params);
    setState(() {
      for(var item in val) {
        // msgList.add(item["msg_id"]);
        if(item["msg_ext_id"] != "" && item["msg_ext_id"] != null) {
          msgMap[item["msg_ext_id"]] = item["msg_id"];
          idList.add(item["msg_ext_id"]);
        }
      }
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

  void _getData(refresh) async {
    /* 刷新与增加数据的逻辑
       刷新：refresh = true的时候，刷新就是将当前的页面置为1，请求数据，然后将所有的列表数据赋值为返回的list数据，count赋值为服务器返回的列表长度
       增加：refresh = null的时候，增加就是将页面的列表数据与服务器返回的列表数据相加，再将count数量加上列表的长度
    */ 
    await _unReadMsg(); // 红点消息已读未读
    // 获取页面数据
    getData(
      widget.workOrderType, refresh == null? _pageNow : 1, 
      widget.workOrderType == '0' || widget.workOrderType == '4'? false : widget.userID).then((data) {
      if(data['total'] == _count) {
        setState(() {
          _count = data['total'];
        });
        _overLoad();
      } else {
        setState(() {
          // 刷新和翻页的逻辑
          refresh == null ? listData += data["list"] : listData = data["list"];
          _count = listData.length;
          for(var item in listData) {
            if(idList.contains(item["ID"].toString())) {
              item["redPoint"] = true;
              item["msgId"] = msgMap[item["ID"].toString()];
            } else {
              item["redPoint"] = false;
              item["msgId"] = "";
            }
          }
        });
      }
    });
  }

  void _refreshData() {
    _getData(true);
  }

  // 时间转换，将昨天，和今天的显示为昨天，今天，而非 XXXX-MM-DD这种格式
  String _converTime(time) {
    DateTime _time = DateTime.parse(time);
    final nowDay = DateTime.now();
    final yesterday = nowDay.subtract(Duration(days: 1));
    int hour = _time.hour;
    int min = _time.minute;
    String _min = "";
    if(min < 10){
      _min = "0$min";
    }
    // 秒暂时未用
    int seconds = _time.second;
    if (_time.day == nowDay.day && _time.month == nowDay.month && _time.year == nowDay.year) {
      return min < 10 ? '$hour:$_min' : '$hour:$min';
    } else if (_time.day == yesterday.day && _time.month == yesterday.month && _time.year == yesterday.year) {
      return min < 10 ? '昨天 $hour:$_min' : '昨天 $hour:$min';
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
            child: Text(
              widget.workOrderType.toString() == '1' ? '我的工单':
              widget.workOrderType.toString() == '0' ? '新工单':
              widget.workOrderType.toString() == '2' ? '我的报修':
              widget.workOrderType.toString() == '3' ? '退单处理':
              widget.workOrderType.toString() == '4' ? '挂起' : '错误',
              style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36))
            )
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
                        statusCallBack: _statusCallBack,
                        waringMsg:warningMap[listData[index]["priority"]],
                        content: listData[index]["taskContent"],
                        fontSize: fontSize,
                        place: listData[index].containsKey("areaName") ? listData[index]["areaName"]: '无',
                        status: statusList[listData[index]["taskNowState"]] == '待验收' ? "" : statusList[listData[index]["taskNowState"]],
                        time: _converTime(listData[index]["addTime"]),
                        orderID: listData[index]["ID"],
                        redPoint: listData[index]["redPoint"],
                        workOrderType: widget.workOrderType,
                        msgID: listData[index]["msgId"],
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

  void _statusCallBack() {
    setState(() {
      _pageNow = 1;
    });
    _getData(true);
  }

  Future _onload() async {
    await Future.delayed(Duration(seconds: 1), (){
      setState(() {
        _pageNow += 1;
      });
      _getData(null);
    });
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _refreshData();
    });
  }
}