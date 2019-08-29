import 'dart:async';
import 'dart:convert';
import '../../config/serviceUrl.dart';
import '../ajax.dart';

Future getOrderData(taskType,userId,flag,pageNum,taskState,paceId,priority,[time=false]) async {
  // taskType: 0 即时工单 1 巡检工单 2 维保工单
  Object _params;
  Map _queryParams = {
    'userId': int.parse(userId),
    'taskType': int.parse(taskType),
    'pageNum': pageNum,
    'flag': flag,
    'pageSize': 10,
    'taskState': taskState,
    'paceId': paceId,
    'priority': priority,
    'dateString': time
  };
  if(time==false) _queryParams.remove('dateString');
  _params = {
    'factor': json.encode(_queryParams)
  };

  final _data = await baseAjax(
    url:servicePath['getTaskInfoList'],
    params: _params
  );
  if (_data != null) {
    return _data;
  }
}
// 获取全部的楼层的Id
Future getPlaceID() async {
  final _data = await baseAjax(url:servicePath['ReportFixId']);
  if (_data != null) {
    return _data;
  }
}
// 获取全部楼层的名字
Future getData() async {
  final _data = await baseAjax(url:servicePath['ReportFixData']);
  if (_data != null) {
    return _data;
  }
}
