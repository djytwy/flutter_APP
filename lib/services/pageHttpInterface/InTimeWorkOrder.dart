import 'dart:async';
import 'dart:convert';
import '../../config/serviceUrl.dart';
import '../ajax.dart';

Future getOrderData(taskType,userId,flag,pageNum,taskState,priority,[time=false,keyWord=false,isDelayed=false]) async {
  // taskType: 0 即时工单 1 巡检工单 2 维保工单
  Object _params;
  Map _queryParams = {
    'userId': int.parse(userId),
    'taskType': int.parse(taskType),
    'pageNum': pageNum,
    'keyWord': '',
    'flag': flag,
    'pageSize': 10,
    'taskState': taskState,
    'priority': priority,
    'dateString': time,
    'keyWord': keyWord,
    'isDelayed': isDelayed
  };
  if(time==false) _queryParams.remove('dateString');
  if(keyWord==false) _queryParams.remove('keyWord');
  if(isDelayed==false) _queryParams.remove('isDelayed');

  final _data = await baseAjax(
    url:servicePath['getTaskInfoList'],
    params: _queryParams,
    method: 'post'
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
