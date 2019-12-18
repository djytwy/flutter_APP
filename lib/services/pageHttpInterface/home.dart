import 'dart:async';
import '../../config/serviceUrl.dart';
import '../ajax.dart';

// 获取即时工单和巡检/维保的数据
Future getTaskCount(token,userId) async {
  var data = await baseAjax(url: servicePath['getTaskCountByTaskType'], params:  {'userId':userId});
  if (data != null) {
    return data;
  }
}
// 获取当前在岗人数的数据
Future getCountPeople(token) async {
  var data = await baseAjax(url: servicePath['getOndutyNum']);
  if (data != null) {
    return data;
  }
}
// 获取工单来源的数据
Future getOrderSource(token,userId) async {
  var data = await baseAjax(url: servicePath['getFrombyType'], params: {'userId':userId});
  if (data != null) {
    return data;
  }
}
// 获取即时工单的数据
Future getCurrentOrder(token,userId) async {
  var data = await baseAjax(url: servicePath['getFromByDepartment'], params: {'userId':userId});
  if (data != null) {
    return data;
  }
}

// 获取当前的在线人数和离线人数
Future toGetOnlineOutline() async {
  var data = await baseAjax(url: servicePath['onlineOutline']);
  if (data != null) {
    return data;
  }
}

