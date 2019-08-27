// 我的任务页面
import 'package:flutter/material.dart';
import '../../services/pageHttpInterface/MyTask.dart';
import '../../utils/util.dart';

// 组件
import './view/ButtonBars.dart';
import '../workOrder/newWorkOrder.dart';

import '../workOrder/chargeback.dart';
import '../workOrder/WorkOrderAccept.dart';

class MyTask extends StatefulWidget {
  MyTask({Key key, }) : super(key: key);
  @override
  _MyTask createState() => _MyTask();
}
class _MyTask extends State<MyTask> {
  bool _work = false; //工单
  bool _shift = true; //排班
  Map pageData = {
    'workOrderNum': 0,
    'repairNum': 0,
    'drawBackNum': 0,
    'newWorkOrderNum': 0
  }; //页面数据
  @override
  void initState(){
    super.initState();
    getInitData();
  }
  // 获取初始化数据
  void getInitData(){
    const data = {
      'userId': 5,
      'submodelId': 2,
      'msgType': 2, // 类型 1:排班， 2： 工单
      // 'msgStatus': 0  //子状态[100-新工单;101-我的工单;102-报修工单;103-退单]不传的时候取对应的所有
    };
    getMyTaskList(data).then((data){
      if(data is Map){
        setState(() {
          pageData = data;
        });
      }
    });
  }
  // 状态改变
  // void didChangeDependencies(){
  //   super.didChangeDependencies();
  //   print('状态改变');
  // }
 
  @override
  Widget build(BuildContext context) {
    // 设置 设计图和设备的 宽高比例
    var _adbapt = SelfAdapt.init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('我的任务', style: TextStyle(fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.transparent
      ),
      body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //居左
              children: <Widget>[
                Container(
                  height: _adbapt.setHeight(44),
                  color: Color.fromRGBO(4, 38, 83, 0.35),
                  margin: EdgeInsets.only(top: _adbapt.setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                              setState(() {
                                _work = false;
                                _shift = true;
                              });
                          },
                          child:  Text('工单处理', textAlign: TextAlign.center, style: 
                            TextStyle( 
                              color:  this._work == false ? Color.fromRGBO(74, 144, 226, 1) : Color.fromRGBO(229,229,229,1)
                              )
                            ),
                        )
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                              setState(() {
                                _work = true;
                                _shift = false;
                              });
                          },
                          child: Center(
                            child: Text('换班处理', style: 
                              TextStyle(
                                color:  this._shift == false ? Color.fromRGBO(74, 144, 226, 1) : Color.fromRGBO(229,229,229,1)
                                )
                              ),
                          ),
                        ),
                      )
                    ],
                  )
                ),
                Offstage( //工单处理
                  offstage: this._work, // 是否隐藏该子组件
                  child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: _adbapt.setHeight(72),
                                color: Color.fromRGBO(4, 38, 83, 0.35),
                                margin: EdgeInsets.only(top: _adbapt.setHeight(10)),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => NewWorkOrder()
                                                ));
                                          },
                                          child: Center(
                                            child: Text('新工单', style: TextStyle(color: Color.fromRGBO(171,171,171,1)),),
                                          ),
                                        ),
                                      )
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        width: _adbapt.setWidth(1),
                                        height: _adbapt.setHeight(44),
                                        color: Color.fromRGBO(76, 135, 179, 1),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                          child: Text(pageData['newWorkOrderNum'].toString(), style: TextStyle(color: Color.fromRGBO(106, 167, 255, 1), fontSize: _adbapt.setFontSize(60)),),
                                        )
                                    )
                                  ],
                                )
                              ),
                              ButtonBars(title:'我的工单', number: pageData['workOrderNum']),
                              ButtonBars(title:'我的报修', number:  pageData['repairNum']),
                              ButtonBars(title:'退单处理', number: pageData['drawBackNum']),
                              ButtonBars(title:'验收', number: pageData['workOrderNum'], callCback: (){
                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => WorkOrderAccept()
                                                ));
                              }),
                              ButtonBars(title:'退单', number: pageData['workOrderNum'], callCback: (){
                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => Chargeback()
                                                ));
                              }),
                            ],
                          ),
                        ),
                ),
                Offstage( //换班处理
                  offstage: this._shift, // 是否隐藏该子组件
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        // ButtonBars(title:'换班申请', number: 0),
                        // ButtonBars(title:'我的处理', number: 0,),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   margin: EdgeInsets.only(left: setWidth(15), top: setHeight(20), bottom: setHeight(10)),
                        //   child: Text('换班结果', style: TextStyle(color: Color.fromRGBO(224, 224, 224, 1), fontSize: setFontSize(15)),),
                        // ),
                        // ButtonBars(title:'审批中', number:  10,),
                        // ButtonBars(title:'已审批', number:  11,),
                      ],
                    ),
                  ),
                )
            ]
          )
        ),
    );
  }
}
