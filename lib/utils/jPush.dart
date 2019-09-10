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
  int userId;
  Jpush.init(){
    jpush = new JPush();
    jpush.applyPushAuthority(); //申请推送权限
    jpush.setup(appKey: jpushAppkey ,channel: 'developer-default');
    getLocalStorage('userId').then((value){
      userId = int.parse(value);
    });
  }
  // 设置别名
  void setAlias(userId){
    jpush.setAlias(userId).then((map) { 
      if (map == null) {
        showTotast('设置推送别名失败！');
      }
    });
  }
  // 设置标签
  void setTags(postId){
    if (postId != null) {
      jpush.setTags([postId]).then((map){
        if (map == null) {
          showTotast('设置推送别名失败！');
        }
      });
    }
  }
  // 监听事件
  void jpushEventHandler(context) async{
    await Future.delayed(Duration(milliseconds: 100));
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        if (message != null) {
          String str = message['extras']['cn.jpush.android.EXTRA'];
          var data = json.decode(str);
          int msgType = int.parse(data['msgType']); //消息类型 1： 排班， 2: 工单
          // int taskId = int.parse(data['taskId']); //任务id
          int taskState = int.parse(data['taskState']); //工单状态
          // int msgStatus = int.parse(data['msgStatus']); //操作状态
          if(msgType == 2){ //工单
            bus.emit("refreshTask");
            if (taskState == 1) { // 新建
              bus.emit("refreshHome");
              return;
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
            int msgStatus = int.parse(data['msgStatus']); //操作状态
            //工单状态  0: 处理中 ，1: 新建， 2: 已完成， 3: 待验收， 4： 退单中， 5: 无法处理， 6： 挂起
            if(msgType == 2){ //工单
              if ( taskState == 0 ) { //处理中
                  Navigator.push(context, MaterialPageRoute( builder: (context) => WorkOrderContent(orderID: taskId) ));
                  return;
              }
              if (taskState == 1) { // 新建
                  Navigator.push(context, MaterialPageRoute( builder: (context) => DispatchSheet(orderID: taskId, isJPush: true) ));
                  return;
              }
              if (taskState == 2) { //已完成
                  Navigator.push(context, MaterialPageRoute( builder: (context) => DetailWordOrder(orderID: taskId) ));
                  return;
              }
              if (taskState == 3) { // 待验收
                  Navigator.push(context, MaterialPageRoute( builder: (context) => WorkOrderAccept(orderID: taskId) ));
                  return;
              }
              if (taskState == 4) { //退单中
                  Navigator.push(context, MaterialPageRoute( builder: (context) => Chargeback(orderID: taskId) ));
                  return;
              }
              if (taskState == 6) { //挂起
                  Navigator.push(context, MaterialPageRoute( builder: (context) => DispatchSheet(orderID: taskId) ));
                  return;
              }
            }else if (msgType == 1) { //排班
              if (taskState == 0) { //新建
                Navigator.push(context, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '3')));
                return;
              }
              if (taskState == 1) { //换班人同意
                Navigator.push(context, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '2')));
                return;
              }
              if (taskState == 2) { //管理员同意
                Navigator.push(context, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '1')));
                return;
              }
              if (taskState == 3) { //换班人拒绝
                Navigator.push(context, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '4')));
                return;
              }
              if (taskState == 4) { //管理员拒绝
                Navigator.push(context, MaterialPageRoute( builder: (context) => ApprovalPendingDetail(id: taskId, type: '1')));
                return;
              }
            }
            // 标记已读
            getChangeWorksStatus({
                'userId': userId,
                'submodelId': 2,
                'msgType': msgType,
                'msgStatus': msgStatus,
                'msgExtId': taskId
            });

          }
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        // print("flutter onReceiveMessage: $message");
      },
    );
  }
}
