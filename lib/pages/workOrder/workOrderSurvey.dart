// 工单概况
import 'package:flutter/material.dart';
import '../../services/pageHttpInterface/MyTask.dart';
import '../../utils/util.dart';

// 页面
import './othersWorkOrderList.dart';
import './inTimeWorkOrder.dart';
// 私有组件
import '../../components/SplitLine.dart';
import './view/PrivateDatePrick.dart';

class WorkOrderSurvey extends StatefulWidget {
  WorkOrderSurvey({Key key, this.taskType}) : super(key: key);
  final taskType;
  @override
  _WorkOrderSurvey createState() => _WorkOrderSurvey();
}
class _WorkOrderSurvey extends State<WorkOrderSurvey> {
  int allCount = 0; //总单数
  String searchValue; //搜索内容
  List pageData = []; //页面数据
  String keyWord; //关键字搜索
  String dateString; //日期字符串
  String choiceClick='工单概况'; // 工单进度、工单概况的按钮 
  var taskType;
  @override
  void initState(){
    super.initState();
    setState(() {
      taskType = widget.taskType is int ? widget.taskType : int.parse(widget.taskType);
      dateString = getCurrentDay();
    });
    getInitData();
  }
  // 初始化 获取数据
  void getInitData(){
    var data = {
      'taskType': taskType, //任务类型 0 及时工单 1巡检 2维保
    };
    if (searchValue != null) {
      data['keyWord'] = searchValue;
    }
    if (dateString != null) {
      data['dateString'] = dateString;
    }
    // 工单概况
    getWorkOrderSurvey(data).then((data){
      if(data is Map) {
        setState(() {
          allCount = data['allCount'];
          pageData = data['userInfo'];
        });
      }
    });
  }
  // 日期选择变化
  datePrickChange(value){
    setState(() {
      dateString = value;
    });
    this.getInitData();
  }
  @override
  Widget build(BuildContext context) {
    var _adapt =  SelfAdapt.init(context);
    String title = taskType == 0 ? '即时工单' : taskType == 1 ? '巡检工单' : taskType == 2 ? '维保工单' : '';
    return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover
              )
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent, 
                centerTitle: true,
                title: Text( title,style: TextStyle(fontSize: _adapt.setFontSize(18))),
                actions: <Widget>[
                  // 时间组件占位
                  PrivateDatePrick(change: datePrickChange)
                ],
              ),
              body: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: _adapt.setHeight(40),
                            padding: EdgeInsets.only(left: _adapt.setWidth(20)),
                            margin: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(10), _adapt.setWidth(15),  _adapt.setHeight(10)),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255,255,255,0.16),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: TextField(
                              maxLines: 1,
                              cursorColor: Colors.white, //光标颜色
                              onSubmitted: (newValue) {
                                this.searchValue = newValue;
                                this.getInitData();
                              },
                              style: TextStyle(
                                color: white_color,
                                fontSize: 14,
                              ),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search, color: Color.fromRGBO(74, 144, 226, 1),),
                                  border: InputBorder.none, // 边框样式
                                  hintText: '请输入姓名进行搜索',
                                  hintStyle: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                              )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              0.0, 
                              _adapt.setHeight(10), 
                              0.0, 
                             _adapt.setHeight(5), 
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
                                      Navigator.pushReplacement(context, MaterialPageRoute(
                                          builder: (context) => InTimeWorkOrder(taskType: taskType.toString())
                                        ));
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: FlatButton(
                                    textColor: choiceClick == '工单概况'? Colors.lightBlue : Colors.white70,
                                    child: Text('工单概况'),
                                    onPressed: (){},
                                  ),
                                )
                              ]),
                          ),
                         Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(8), _adapt.setWidth(15), 0),
                            child: Text('共$allCount单', style: TextStyle(color: Color.fromRGBO(165, 165, 165, 1), fontSize: _adapt.setFontSize(12))),
                          ),
                          Expanded(
                            child: ListView.builder(
                                    itemCount: pageData.length,
                                    itemBuilder: (context, index) {
                                      var item = pageData[index];
                                      String countName = item['count'] != null ? '（共' + item['count'].toString() + '单）' : '';
                                      return Container(
                                          color: module_background_color,
                                          margin: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(8), _adapt.setWidth(15), 0),
                                          padding: EdgeInsets.only(left: _adapt.setWidth(20)),
                                          child: GestureDetector(
                                            onTap: (){
                                                 Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => OthersWorkOrderList(userId: item['user_id'], userName: item['user_name'], taskType: taskType)
                                                ));
                                            },
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: _adapt.setHeight(43),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text( item['user_name'] == null ? '' : item['user_name'] , style: TextStyle(color: white_color, fontSize: _adapt.setFontSize(16))),
                                                        Text( countName , style: TextStyle(color: Color.fromRGBO(173, 216, 255, 1), fontSize: _adapt.setFontSize(16))),
                                                      ],
                                                    ),
                                                  ),
                                                  SplitLine(),
                                                  Container(
                                                    height: _adapt.setHeight(43),
                                                    decoration: BoxDecoration(
                                                      // borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text('今日派单 ' + item['todayCount'].toString(), style: TextStyle(color: white_name_color, fontSize: _adapt.setFontSize(15))),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text('未完成 '+ item['wei'].toString(), style: TextStyle(color: Color.fromRGBO(255, 89, 89, 1), fontSize: _adapt.setFontSize(15))),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text('完成率 ' + item['rate'], style: TextStyle(color: Color.fromRGBO(80, 227, 194, 1), fontSize: _adapt.setFontSize(15))),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                            ),
                                          ),
                                        );
                                    },
                              ),
                          ),
                        ],
                      ), 
                    )
          )
        );
  }
}