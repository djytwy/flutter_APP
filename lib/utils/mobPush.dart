// 基础库
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
// mobPush插件
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:mobpush_plugin/mobpush_custom_message.dart';
import 'package:mobpush_plugin/mobpush_notify_message.dart';
// 发起请求绑定别名
import '../services/pageHttpInterface/Login.dart';
import './util.dart';
import '../utils/eventBus.dart';

// 需要跳转的页面
import '../services/pageHttpInterface/shiftDuty.dart'; // 排班
import '../pages/workOrder/dispatchSheet.dart'; // 派发工单
import '../pages/workOrder/workOrderContent.dart'; // 退单 / 提交
import '../pages/workOrder/workOrderAccept.dart'; // 验收
import '../pages/workOrder/chargeback.dart'; // 退单审核
import '../pages/workOrder/detailWorkOrder.dart'; //工单详情
import '../pages/shiftDuty/approvalPendingDetail.dart'; // 待审批


class MobPush with ChangeNotifier {
  // 初始化
  void init(){
    if (Platform.isIOS) {
      MobpushPlugin.setCustomNotification();
      MobpushPlugin.setAPNsForProduction(false);
    }
    MobpushPlugin.addPushReceiver(_onEvent, _onError);
  }

  // mob推送（接收事件）
  void _onEvent(Object event) {
    print('mobPush推送消息:' + event.toString());
    Map<String, dynamic> eventMap = json.decode(event);
    Map<String, dynamic> result = eventMap['result'];
    Map<String, dynamic> msg = result['extrasMap'];
    int action = eventMap['action'];

    final ctx = CTX.currentState.overlay.context;

    switch (action) {
      case 0:
        MobPushCustomMessage message = MobPushCustomMessage.fromJson(result);
        break;
      case 1:
        // 收到通知的处理逻辑
        MobPushCustomMessage message = MobPushCustomMessage.fromJson(result);
        bus.emit('refreshList');
        break;
      case 2:
        // 点击通知的跳转逻辑
        MobPushNotifyMessage message = MobPushNotifyMessage.fromJson(result);
        _toPage(ctx, msg);
        break;
    }
  }

  // mob推送（错误处理）
  void _onError(Object event) {
    print('mobPush推送错误：' + event.toString());
  }

  // 不同通知，不同的跳转
  Future<void> _toPage(ctx,data) async {
    String userId = await getLocalStorage('userId');
    int msgType = int.parse(data['msgType']); //消息类型 1： 排班， 2: 工单
    int taskId = int.parse(data['taskId']); //任务id
    int taskState = int.parse(data['taskState']); //工单状态
    int msgStatus = data.containsKey('msgStatus') ? int.parse(data['msgStatus']) : null; //操作状态
    // 标记已读
    if(msgStatus != null)
      getChangeWorksStatus({
        'userId': userId,
        'submodelId': 2,
        'msgType': msgType,
        'msgStatus': msgStatus,
        'msgExtId': taskId,
        'operFlag': 3,
      });
    String pageFlag = msgType.toString() + taskState.toString();
    Map<String,dynamic> pageMap = {
      '20': WorkOrderContent(orderID: taskId),  // 工单——处理中
      '21': DispatchSheet(orderID: taskId, isJPush: true), // 工单——新建
      '22': DetailWordOrder(orderID: taskId), // 工单——已完成
      '23': WorkOrderAccept(orderID: taskId), // 工单——待验收
      '24': Chargeback(orderID: taskId),   // 工单——退单中
      '26': DispatchSheet(orderID: taskId), // 工单——挂起
      '10': ApprovalPendingDetail(id: taskId, type: '3'), // 排班——新建
      '11': ApprovalPendingDetail(id: taskId, type: '2'), // 排班——换班人同意
      '12': ApprovalPendingDetail(id: taskId, type: '1'), // 排班——管理员同意
      '13': ApprovalPendingDetail(id: taskId, type: '4'), // 排班——换班人拒绝
      '14': ApprovalPendingDetail(id: taskId, type: '1')  // 排班——管理员拒绝
    };
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => pageMap[pageFlag]));
  }

  // 绑定别名、获取SDK版本
  Future<void> bindAlias(userId,positionId) async {
    Map<String,dynamic> _registrationID = await MobpushPlugin.getRegistrationId();
    String sdkVersion;
    try {
      sdkVersion = await MobpushPlugin.getSDKVersion();
      print('MobPush SDK版本： $sdkVersion');
    } on PlatformException {
      sdkVersion = 'Failed to get platform version.';
    }
    print('MobPush 注册编码: $_registrationID');
    // 发送绑定请求到后端
    getSendRegistId({
      'userId': userId is int ? userId : int.parse(userId),
      'RegistrationID': _registrationID['res'],
      'positionId': positionId is int ? positionId : int.parse(positionId)
    });
  }
}
