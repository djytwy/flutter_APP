import 'dart:async';
import '../../config/serviceUrl.dart';
import '../ajax.dart';
// 获取及时工单和巡检/维保的数据
Future getTaskCount(token,userId,date) async {
  var data = await baseAjax(url: servicePath['getTaskCountByTaskType'], params:  {'dateString':date,'userId':userId});
  if (data != null) {
    return data;
  }
}
// 获取当前在岗人数的数据
Future getCountPeople(token,date) async {
  var data = await baseAjax(url: servicePath['getOndutyNum'], params:  {'dateString':date});
  if (data != null) {
    return data;
  }
}
// 获取工单来源的数据
Future getOrderSource(token,userId,date) async {
  var data = await baseAjax(url: servicePath['getFrombyType'], params: {'dateString':date,'userId':userId});
  if (data != null) {
    return data;
  }
}
// 获取即时工单的数据
Future getCurrentOrder(token,userId,date) async {
  var data = await baseAjax(url: servicePath['getFromByDepartment'], params: {'dateString':date,'userId':userId});
  if (data != null) {
    return data;
  }
}

