import 'package:app_tims_hotel/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/listItem.dart';
import '../../components/textLabel.dart';
import '../../services/pageHttpInterface/detailWorkOrder.dart';
import '../../components/customStepper.dart';

class DetailWordOrder extends StatefulWidget {
  DetailWordOrder({
    Key key, 
    this.orderID,
    this.showExtime=true   
  }) : super(key: key);
  final orderID;
  final showExtime;   // 是否显示完成时限

  _DetailWordOrderState createState() => _DetailWordOrderState();
}

class _DetailWordOrderState extends State<DetailWordOrder> {

  String reportPeople = '暂无';   // 报修人
  String department = "";     // 报修部门
  String copyPeople = '暂无';   // 抄送人
  String handlePost = '总经理';         // 处理岗位
  String handlePeople =  '华阳吴亦凡';    // 处理人
  String grade = '高优先级';  // 优先级
  String content = '暂无';  //  内容
  String complete = '5天';  // 完成时限
  String handlePhone = '10086';  // 处理人电话
  String reportPhone = '10086';  // 报修人电话
  String status = "";  // 任务状态
  String day = "天"; // 完成时限

  Map statusMap = {"0": "处理中", "1": "新建" ,"2":"已完成", "3":"待验收", "4":"退单中", "5":"无法处理", "6":"挂起"};
  Map gradeMap = {"1":"低优先级","2":"中优先级","3":"高优先级"};
  Map progressMap = {"0":"接单时间","1":"派单时间","2":"完成时间","9":"验证时间"};  // 时间线进度
  List timeList = ["接单时间", "派单时间","完成时间","验证时间"];

  dynamic orderID;
  List picList = [];

  // 时间线列表
  Future stepList;
  Future reData;

  @override
  void initState() {
    // TODO: implement initState
    orderID = widget.orderID;
    _getData();
    super.initState();
  }

  void _getData(){
    getLocalStorage('userId').then((userId) async {
      dynamic _reData = await getData(orderID, userId);
      // 用于futureBuilder
      setState(() {
        reData = getData(orderID, userId);
      });
      String _copyPeople = "";
      dynamic _picList = [];
      String _day = '未知';    

      for(var item in _reData["mainInfo"]["copyUserList"]) {
        _copyPeople += item;
      }

      if(_reData["taskPictureInfo"] is List ) {
        _picList = _reData["taskPictureInfo"].map((v) => "https://tesing.china-tillage.com"+v['picUrl'].toString());
      }

      if(_reData["mainInfo"].containsKey("anticipatedTime")) {
        _day = _reData["mainInfo"]["anticipatedTime"].toString() + day;
      }
 
      setState(() {
        picList = _picList.toList();   // 图片列表
        reportPeople = _reData["mainInfo"]["sendUserName"];   // 报修人
        department = _reData["mainInfo"]["sendDepartment"];
        copyPeople = _copyPeople;   // 抄送人
        handlePost = _reData["mainInfo"].containsKey("handleRoleName") ? _reData["mainInfo"]["handleRoleName"] : "暂无";         // 处理岗位
        handlePeople = _reData["mainInfo"]["handleUserName"];    // 处理人
        grade = gradeMap[_reData["mainInfo"]["priority"].toString()];  // 优先级
        content = _reData["mainInfo"]["taskContent"];  //  内容
        complete = _reData["mainInfo"]["sendUserName"];  // 完成时限
        handlePhone = _reData["mainInfo"]["handleUserPhone"]; // 处理人电话
        reportPhone = _reData["mainInfo"]["sendUserPhone"]; // 报修人电话
        status = statusMap[_reData["mainInfo"]["taskState"].toString()];   // 任务状态
        day = _day;  // 完成时限
      });
    });

  }

  String _secToTime(s) {
    String _hour = '';
    String _min = '';
    String t ='';
    if(s > -1){
      double hour = s/3600;
      double min = s/60 % 60;
      if(hour < 10) {
        if (hour != 0) {
          _hour += "0" + hour.toInt().toString() + "小时";
        } else {
          _hour = "";
        }
      } else {
        _hour = hour.toInt().toString() + " 小时";
      }

      if(min < 10){
        if (min != 0) {
          _min += "0" + min.toInt().toString() + " 分";
        } else {
          _min = "0分";
        }
      } else {
        _min += min.toInt().toString() + " 分";
      }
    }
    t = _hour + _min;
    return t;
  }

  List<Widget> boxs(length) => List.generate(length, (index) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(360),
      height: ScreenUtil.getInstance().setHeight(270),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Image.network(
          picList[index],
          width: ScreenUtil.getInstance().setWidth(340),
          height: ScreenUtil.getInstance().setHeight(255),
          fit: BoxFit.cover,
        ),
      )
    );
  }); 

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
     double fontSize = ScreenUtil.getInstance().setSp(30);
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
            child: Text('工单详情',style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)))
          ),
          actions: <Widget>[          // 占位，保持居中
            Container(
              width: ScreenUtil.getInstance().setWidth(120),
              child: Text('')
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(16)),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: TextLable(
                            broderColor: grade == "高优先级" ? Color.fromARGB(255, 239, 111, 111):
                                         grade == "中优先级" ? Colors.yellowAccent[100]:
                                         Colors.greenAccent[400],
                            text: grade, 
                            bgcolor: grade == "高优先级" ? Color.fromARGB(120, 82, 52, 56):
                                     grade == "中优先级" ? Colors.yellow[800]:
                                     Colors.green[900],
                          ),
                        ),
                        Expanded(
                          child: TextLable(
                            align: 'right',
                            broderColor: Color.fromARGB(255, 142, 245, 108), 
                            text: status, 
                            bgcolor: Color.fromARGB(255, 42, 83, 57)
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(120)),
                      child: FutureBuilder(
                        future: reData,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none: 
                              break;
                            case ConnectionState.active:
                              print('请求发起');
                              break;
                            case ConnectionState.waiting:
                              print('等待响应');
                              break;
                            case ConnectionState.done:
                              Map _stepMap={};  // 用于存储step的map，格式：{state: {time}}
                              List _stepList=[];  // stepper渲染的list
                              List _toSortList=[];   // 排序之后的list，后台返回的数据是无序的

                              dynamic _preTime;    // 用于计算两次时间的时间差
                              dynamic _time;      // 一个时间差
                              List _timeList = [];  // 时间差的列表

                              for (var item in snapshot.data["taskLineInfo"]){
                                _toSortList.add(item["taskState"]);                            
                                _stepMap[item["taskState"]] = {"time":item["addTime"]};
                              }

                              for(var item in _toSortList) {
                                _stepList.add({
                                  'text':progressMap[item.toString()],
                                  'time':_stepMap[item]["time"]
                                });
            
                                if(_preTime != null) {
                                  _time = DateTime.parse(_stepMap[item]["time"]).difference(_preTime).inSeconds;
                                  _time = _secToTime(_time);
                                  _timeList.add(_time);
                                  _preTime = DateTime.parse(_stepMap[item]["time"]);
                                } else {
                                  _preTime = DateTime.parse(_stepMap[item]["time"]);
                                }
                              }

                              // 由于时间差的值始终比进度点少一个，但是渲染需要数量相同才行，所以补一个空
                              _timeList.add("");
                              return CustomStepper(
                                currentStep: _timeList.length - 1,
                                type: CustomStepperType.vertical,
                                steps: _stepList
                                  .map(
                                    (s) => CustomStep(
                                      // title: Text(s, style: TextStyle(color: Colors.white70)), 
                                      title: Row(children: <Widget>[
                                        Text(s["text"] + ": ", style: TextStyle(color: Colors.white70)),
                                        Text(s["time"], style: TextStyle(color: Colors.white70,fontSize: 12.0))
                                      ]),
                                      content: Container(), 
                                      isActive: true, 
                                      status: _timeList[_stepList.indexOf(s)]
                                    ),
                                  )
                                  .toList(),
                                controlsBuilder: (BuildContext context,
                                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                                  return Container();
                                },
                              );
                              break;
                            default:
                          }
                          return Text('请求测试');
                        },
                      ),
                    ),
                    Offstage(
                      offstage: reportPeople == null,
                      child: ListItem(title: '报修人', content: '$reportPeople ($department)', border: true, phone: false, phoneNum: reportPhone,),
                    ),
                    ListItem(title: '抄送人', content: copyPeople == null ? "暂无" : copyPeople,border: true),
                    ListItem(title: '处理岗位', content: handlePost == null ? "暂未处理" : handlePost,border: true,),
                    ListItem(title: '处理人', content: handlePeople == null ? "暂未处理" : handlePeople, phone: false, phoneNum: handlePhone),
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
                            child: Text('内容',style: TextStyle(fontSize: fontSize,color: Colors.white70)),
                          ),
                          Container(
                            width: ScreenUtil.getInstance().setWidth(690),
                            child: Text('$content', maxLines: 5,style: TextStyle(fontSize: fontSize,color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !widget.showExtime,
                      child: ListItem(title: '完成时限', content: day,color: Colors.greenAccent),
                    ),
                    Container(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: boxs(picList.length),
                      ),
                      margin: EdgeInsets.fromLTRB(
                        0.0, 
                        ScreenUtil.getInstance().setHeight(20), 
                        0.0, 
                        ScreenUtil.getInstance().setHeight(20)
                      ),
                    ), 
                    ListItem(title: '工单编号：$orderID', content: "",),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}