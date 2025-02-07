// 工单验收
import 'package:flutter/material.dart';
import '../../services/pageHttpInterface/MyTask.dart';
import '../../utils/util.dart';

// 组件
import '../../components/ListBarComponents.dart';
import '../../components/ButtonsComponents.dart';
import './view/MultipleRowTexts.dart';
import './view/ImageList.dart';
import '../../components/SplitLine.dart';

// 退单原因
import './view/repairReason.dart';
// 抄送人
import 'view/copierItem.dart';
import '../../components/listItem.dart';

class WorkOrderAccept extends StatefulWidget {
  WorkOrderAccept({Key key, this.orderID}) : super(key: key);
  final orderID;
  @override
  _WorkOrderAccept createState() => _WorkOrderAccept();
}
class _WorkOrderAccept extends State<WorkOrderAccept> {
  var userId; //用户id
  int taskId; //工单id
  List pictureList = []; // 处理后的图片列表
  List beforePicList = []; // 处理前的图片
  Map pageData = {//页面数据
    'areaName': '', //地点
    'taskContent': '', // 内容
    'addTime': '', //时间
    'priority': 0, // 优先级
    'sendUserName': '', // 报修人 名字
    'sendUserPhone':'', // 保修人电话号码
    'handleUserPhone': '', //处理人电话
    'sendUserId': 0, // 报修人id
    'ID': -1, // 工单id
    'copyUserList': [],
    'roomState': '空脏'
  };
  List copierList = [];
  // 房间状态
  Map _dicColors = {
    '空脏':Color.fromARGB(255, 239, 111, 111),
    '住脏':Color.fromARGB(255, 239, 111, 111),
    '空净':Color.fromARGB(255, 111, 185, 239),
    '住净':Color.fromARGB(255, 111, 185, 239),
    '锁门': Color.fromARGB(255, 239, 152, 111),
    '维修': Color.fromARGB(255, 239, 152, 111),
  };

  @override
  void initState(){
    super.initState();
    taskId = ( widget.orderID is int) ? widget.orderID : int.parse(widget.orderID);
    getLocalStorage('userId').then((data){
      userId = (data is int) ? data : int.parse(data);
      getInitData();
    });
  }
  // 初始化 获取数据
  void getInitData(){
    var data = {
      'userId': userId, //用户id
      'taskId': taskId, //工单id
    };
    // 工单信息
    getWorkOrderDetail(data).then((data){
      if(data is Map){
        setState(() {
          pageData = data['mainInfo'];
          pictureList = data['mainInfo']['taskPictureInfo']["afterProcessing"];
          beforePicList = data['mainInfo']['taskPictureInfo']["beforeProcessing"];
        });
      }
    });
  }
  /* 处理
   * @param optionType: 工单处理类型 0 指派给自己 1 指派给别人 2处理完成 3申请退单 4 同意退单 5 拒绝退单 6 验收通过 7 验收不通过 8无法处理 9挂起
   */
  void dispatchSheet({ optionType: int }) {
    if(optionType == 7) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RepairReason(
        optionType: 7,
        orderID: pageData['ID'],
      )));
    } else {
      int taskId = pageData['ID'];
      Map params = {
        'now_userId': userId, //用户id
        'id': taskId, //工单id
      };
      params['optionType'] = optionType;
      params['copyUser'] = copierList;
      // 处理
      getdispatchSheet(params).then((data){
        if(data is bool && data == true){
          Navigator.pop(context, true);
        }
      });
    }
  }

  // 回调函数获得选中的抄送人ID
  void _getCopierID(List _copierList) {
    dynamic tempList = _copierList.map((e) => e["userID"]);
    setState(() {
      copierList = tempList.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _adapt =  SelfAdapt.init(context);
    // 判断 优先级
    int priority = pageData['priority'];
    String priorityName =  priority == 3 ? '优先级高' : priority == 2 ? '优先级中' : priority == 1 ? '优先级低' : '';
    // 工单号-- 工单id
    int taskId = pageData['ID'];
    //报修人
    String reporter = pageData['sendUserName'];
    if(pageData['sendDepartment'] != null){
      String sendDepartment = pageData['sendDepartment'];
      reporter = reporter + ' ($sendDepartment)';
    }
    //处理人
    String handler = pageData['handleUserName'];
    if(pageData['handleDepartment'] != null){
      String handleDepartment = pageData['handleDepartment'];
      handler = handler + ' ($handleDepartment)';
    }
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
          title: Text('工单内容',style: TextStyle(fontSize: _adapt.setFontSize(18))),
          centerTitle: true,
          backgroundColor: Colors.transparent
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //居左
                    children: <Widget>[
                      Container( //标签按钮
                        child: Container(
                          child:Center(
                            child:Text( priorityName, style:TextStyle(color: white_color))
                          ),
                          width: _adapt.setWidth(96),
                          height: _adapt.setHeight(30),
                          decoration: new BoxDecoration(
                            border: new Border.all(width: _adapt.setWidth(1), color: Color.fromRGBO(239, 111, 111, 1)),
                            color: Color.fromRGBO(239, 111, 111, 0.18),
                            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                          )
                        ),
                        margin: EdgeInsets.only(left: _adapt.setWidth(15), right: _adapt.setWidth(15), top: _adapt.setHeight(15), bottom: _adapt.setHeight(15)),
                      ),
                      Container( //地点/时间
                        child: Column(children: <Widget>[
                          ListBarComponents(name:'地点', value: pageData['areaName'],labelWidget: StatusButton(color: _dicColors[pageData['roomState']], label: pageData['roomState'])),
                          SplitLine(),
                          ListBarComponents(name:'时间', value: pageData['addTime']),
                        ]),
                        height: _adapt.setHeight(131),
                        width: double.infinity,
                        color: module_background_color,
                        padding: EdgeInsets.only(left: _adapt.setWidth(15)),
                      ),
                      Container( //报修人/抄送人/处理岗位/处理人
                        child: Column(children: <Widget>[
                          ListBarComponents(name:'报修人', value: reporter, ishidePhone: false, tel: pageData['sendUserPhone']),
                          SplitLine(),
                          ListBarComponents(name:'抄送人', value: pageData['copyUserList'].join(',')),
                          SplitLine(),
                          ListBarComponents(name:'处理岗位', value: pageData['handleRoleName']),
                          SplitLine(),
                          ListBarComponents(name:'处理人', value: handler, ishidePhone: false, tel: pageData['handleUserPhone']),
                          SplitLine(),
                        ]),
                        height: _adapt.setHeight(195),
                        width: double.infinity,
                        color: module_background_color,
                        padding: EdgeInsets.only(left: _adapt.setWidth(15.0)),
                        margin: EdgeInsets.only(top: _adapt.setHeight(8.0)),
                      ),
                      CopierItem(clickCB: _getCopierID),
                      Offstage(
                        offstage: pageData["deviceName"] == null || pageData["deviceName"] == "",
                        child: ListItem(title: '设备', content: pageData["deviceName"] == null || pageData["deviceName"] == "" ? "暂无" : pageData["deviceName"]),
                      ),
                      MultipleRowTexts(name:'内容', value: pageData['taskContent']),
                      Offstage(
                        offstage: pageData['remarks'] == "" || pageData['remarks'] == " ",
                        child: MultipleRowTexts(name:'备注', value: pageData['remarks']),
                      ),
                      SizedBox(
                        height: _adapt.setHeight(20),
                      ),
                      // 处理前照片
                      Offstage(
                        offstage:  pictureList.length > 0 ? false : true,
                        child: Container(
                          child: Text('处理前照片', style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                      Offstage(
                        offstage:  beforePicList.length > 0 ? false : true,
                        child: ImageList(data: beforePicList),
                      ),
                      // 占位
                      SizedBox(
                        height: _adapt.setHeight(20),
                      ),
                      // 处理后照片
                      Offstage(
                        offstage:  pictureList.length > 0 ? false : true,
                        child: Container(
                          child: Text('处理后照片', style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                      Offstage(
                        offstage:  pictureList.length > 0 ? false : true,
                        child: ImageList(data: pictureList),
                      ),
                      Container(
                        child: Text('工单号: $taskId', style: TextStyle(color: white_name_color)),
                        margin: EdgeInsets.only(top: _adapt.setHeight(19), bottom: _adapt.setHeight(20)),
                        padding: EdgeInsets.only(left: _adapt.setWidth(15)),
                      ),
                  ]
                )
              ),
            ),
            ButtonsComponents(leftName: '重修',rightName: '通过', cbackLeft: (){dispatchSheet(optionType: 7);}, cbackRight: (){dispatchSheet(optionType: 6);})
          ],
        )
    )
    );
  }
}


class StatusButton extends StatefulWidget {

  StatusButton({
    Key key,
    this.color,
    this.label
  }):super();
  final color;
  final label;

  @override
  _StatusButtonState createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    var _adapt =  SelfAdapt.init(context);
    return Container(
      margin: EdgeInsets.only(right: _adapt.setWidth(15)),
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(3))
        ),
        width:_adapt.setWidth(40),
        height: _adapt.setHeight(20),
        child: Center(
          child: Text(widget.label,style: TextStyle(color: Colors.white)),
        )
      )
    );
  }
}


//class StatusButton extends StatelessWidget {
//  StatusButton({
//    Key key,
//    this.color,
//    this.label
//  }):super();
//  final color;
//  final label;
//
//  @override
//  Widget build(BuildContext context) {
//    var _adapt =  SelfAdapt.init(context);
//    return Container(
//      margin: EdgeInsets.only(right: _adapt.setWidth(15)),
//      alignment: Alignment.centerRight,
//      child: Container(
//        decoration: BoxDecoration(
//          color: this.color,
//          borderRadius: BorderRadius.all(Radius.circular(3))
//        ),
//        width:_adapt.setWidth(40),
//        height: _adapt.setHeight(20),
//        child: Center(
//          child: Text(this.label,style: TextStyle(color: Colors.white)),
//        )
//      )
//    );
//  }
//}