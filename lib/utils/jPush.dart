// 处理推送逻辑
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import '../config/config.dart';
import './util.dart';
import 'dart:convert';

import '../pages/workOrder/dispatchSheet.dart'; // 派发工单
import '../pages/workOrder/workOrderContent.dart'; // 退单 / 提交 
import '../pages/workOrder/workOrderAccept.dart'; // 验收
import '../pages/workOrder/chargeback.dart'; // 退单审核
import '../pages/workOrder/detailWorkOrder.dart'; //工单详情



class Jpush{
  JPush jpush;
  Jpush.init(){
    jpush = new JPush();
    jpush.setup(appKey: jpushAppkey ,channel: 'developer-default');
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
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        // print("flutter onOpenNotification: $message");
        if (message != null) {
          String str = message['extras']['cn.jpush.android.EXTRA'];
          var data = json.decode(str);
          int msgType = int.parse(data['msgType']); //消息类型 1： 排班， 2: 工单
          int taskId = int.parse(data['taskId']); //任务id
          // int taskType = int.parse(data['taskType']); //工单类型
          int taskState = int.parse(data['taskState']); //工单状态
          //工单状态  0: 处理中 ，1: 新建， 2: 已完成， 3: 待验收， 4： 退单中， 5: 无法处理， 6： 挂起
          if(msgType == 2){ //工单
            if ( taskState == 0 ) { //处理中
                Navigator.push(context, MaterialPageRoute( builder: (context) => WorkOrderContent(orderID: taskId) ));
                return;
            }
            if (taskState == 1) { // 新建
                Navigator.push(context, MaterialPageRoute( builder: (context) => DispatchSheet(orderID: taskId) ));
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
