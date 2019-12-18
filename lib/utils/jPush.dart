// 处理推送逻辑
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import '../config/config.dart';
import './util.dart';
import 'dart:convert';
import '../utils/eventBus.dart';

import '../services/pageHttpInterface/shiftDuty.dart';
import '../pages/workOrder/dispatchSheet.dart'; // 派发工单
import '../pages/workOrder/workOrderContent.dart'; // 退单 / 提交 
import '../pages/workOrder/workOrderAccept.dart'; // 验收
import '../pages/workOrder/chargeback.dart'; // 退单审核
import '../pages/workOrder/detailWorkOrder.dart'; //工单详情
import '../pages/shiftDuty/approvalPendingDetail.dart';

class Jpush{
  JPush jpush;
  var userId;
  Jpush.init(){
    jpush = new JPush();
    jpush.applyPushAuthority(); //申请推送权限
    jpush.setup(appKey: jpushAppkey ,channel: 'developer-default');
    getLocalStorage('userId').then(((val){
      userId = val;
    }));
  }
  // 监听事件
  void jpushEventHandler(context) async {
    await Future.delayed(Duration(milliseconds: 100));
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        if (message != null) {
          String str = message['extras']['cn.jpush.android.EXTRA'];
          var data = json.decode(str);
          int msgType = int.parse(data['msgType']); // 消息类型 1： 排班， 2: 工单
          int taskState = int.parse(data['taskState']); // 工单状态
          // int copyUserFlag = int.parse(data['copyUserFlag']); // 抄送人
          // 需求未定，暂时注释。 2019-11-19
//          if(copyUserFlag == 1) {
//            // 刷新未读工单
//            bus.emit("getUnreadWorkOrder");
//          }
          if(msgType == 1 || msgType == 2){
            bus.emit("refreshTask", false);
            bus.emit('refreshMenu');
          }
          if(msgType == 2) { //工单
            if (taskState == 1) { // 新建
              bus.emit("refreshHome");
              return;
            } else if (taskState == 0) {
              if(data["title"].toString().contains("及时处理")) {
                bus.emit('refreshList');
              }
            }
          }
        }
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        if (message != null) {
            String str = message['extras']['cn.jpush.android.EXTRA'];
            var data = json.decode(str);
            int msgType = int.parse(data['msgType']); //消息类型 1： 排班， 2: 工单
            int taskId = int.parse(data['taskId']); //任务id
            int taskState = int.parse(data['taskState']); //工单状态
            int msgStatus = data.containsKey('msgStatus') ? int.parse(data['msgStatus']) : null; //操作状态
            dynamic buttonIsUsable = data['buttonIsUsable'] ?? null;
             // 标记已读
            if(msgStatus != null){
              getChangeWorksStatus({
                  'userId': userId,
                  'submodelId': 2,
                  'msgType': msgType,
                  'msgStatus': msgStatus,
                  'msgExtId': taskId,
                  'operFlag': 3,
              });
            }
            // 工单状态  0: 处理中 ，1: 新建， 2: 已完成， 3: 待验收， 4： 退单中， 5: 无法处理， 6： 挂起
            // 工单状态中buttonIsUsable有值的时候 则跳工单详情页面
            // 获取上下文
            var ctx = CTX.currentState.overlay.context;
            if(msgType == 2){ //工单
              if( buttonIsUsable != null ) {  // 质检人员看到的直接跳工单详情页
                  Navigator.push(ctx, MaterialPageRoute(builder: (context) => DetailWordOrder(orderID: taskId,showExtime: false)));
                  return;
              }
              if ( taskState == 0 ) { //处理中
                  Navigator.push(ctx, MaterialPageRoute( builder: (context) => WorkOrderContent(orderID: taskId)));
                  return;
              }
              if (taskState == 1) { // 新建
                  Navigator.push(ctx, MaterialPageRoute( builder: (context) => DispatchSheet(orderID: taskId, isJPush: true) ));
                  return;
              }
              if (taskState == 2) { //已完成
                  Navigator.push(ctx, MaterialPageRoute( builder: (context) => DetailWordOrder(orderID: taskId) ));
                  return;
              }
              if (taskState == 3) { // 待验收
                  Navigator.push(ctx, MaterialPageRoute( builder: (context) => WorkOrderAccept(orderID: taskId) ));
                  return;
              }
              if (taskState == 4) { //退单中
                  Navigator.push(ctx, MaterialPageRoute( builder: (context) => Chargeback(orderID: taskId) ));
                  return;
              }
              if (taskState == 6) { //挂起
                  Navigator.push(ctx, MaterialPageRoute( builder: (context) => DispatchSheet(orderID: taskId) ));
                  return;
              }
            }else if (msgType == 1) { //排班
              if (taskState == 0) { //新建
                Navigator.push(ctx, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '3')));
                return;
              }
              if (taskState == 1) { //换班人同意
                Navigator.push(ctx, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '2')));
                return;
              }
              if (taskState == 2) { //管理员同意
                Navigator.push(ctx, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '1')));
                return;
              }
              if (taskState == 3) { //换班人拒绝
                Navigator.push(ctx, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '4')));
                return;
              }
              if (taskState == 4) { //管理员拒绝
                Navigator.push(ctx, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '1')));
                return;
              }
            }
          }
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        // print("flutter onReceiveMessage: $message");
      },
    );
  }
}
