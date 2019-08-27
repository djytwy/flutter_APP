import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/workOrder/detailWorkOrder.dart';
import '../pages/workOrder/dispatchSheet.dart';

class WorkOrderItem extends StatefulWidget {
  WorkOrderItem({
    Key key, 
    this.waringMsg, 
    this.content,
    this.fontSize,
    this.status,
    this.time,
    this.place,
    this.statusCallBack,
    this.redPoint=false
    }) : super(key: key);

  String waringMsg;         // 传入组件的紧急程度（高、中、低）
  String time;              // 传入组件的时间
  String status;            // 传入组件的状态信息（工单列表相关界面用：维保工单，巡检工单，工单进度）
  String content;           // 传入组件的文本内容
  String place;             // 传入组件的地点信息
  double fontSize;          // 传入组件的字体大小
  String orderID;           // 工单的ID
  final redPoint;           // 是否红点推送
  final statusCallBack;     // 组件的回调函数，返回？信息

  _WorkOrderItemState createState() => _WorkOrderItemState();
}

class _WorkOrderItemState extends State<WorkOrderItem> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Container(
      margin: EdgeInsets.fromLTRB(
        ScreenUtil.getInstance().setHeight(16),
        ScreenUtil.getInstance().setHeight(16),
        ScreenUtil.getInstance().setHeight(16),
        ScreenUtil.getInstance().setHeight(16)
      ),
      padding:EdgeInsets.all(ScreenUtil.getInstance().setHeight(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Color.fromARGB(100, 12, 33, 53),
        boxShadow: [
          BoxShadow(
            color: Color(0x60000000),
            blurRadius: 5.0
          )
        ]
      ),
      width: ScreenUtil.getInstance().setWidth(690),
      height: ScreenUtil.getInstance().setHeight(274),
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(30)),
                    alignment: Alignment.topLeft,
                    child: widget.waringMsg == '高'? Text(widget.waringMsg, style: TextStyle(color: Colors.redAccent)) : 
                      widget.waringMsg == '中'? Text(widget.waringMsg, style: TextStyle(color: Colors.yellowAccent)):
                      Text(widget.waringMsg, style: TextStyle(color: Colors.greenAccent)),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Offstage(
                        offstage: !widget.redPoint,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ) 
                    ),
                  )
                ],
              )
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(15)), 
                    alignment: Alignment.centerLeft,
                    child: Text(widget.time, textAlign: TextAlign.left ,style: TextStyle(color: Colors.white70, fontSize: widget.fontSize)),
                  ),
                  Expanded(
                    child: Text(widget.status, textAlign: TextAlign.right,style: TextStyle(color: Colors.greenAccent,fontSize: widget.fontSize))  
                  )
                ] 
              )
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(14)),
              child: Center(
                child: Text(widget.content, style: TextStyle(color: Colors.white70,fontSize: widget.fontSize)),
              )
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(24)),
              alignment: Alignment.centerLeft,
              child: Text(widget.place, style: TextStyle(color: Colors.white,fontSize: widget.fontSize)),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => DispatchSheet(orderID:26)
          ));
        },
      )
    );
  }

  void _statusCallBack() {
    widget.statusCallBack();
  }
}