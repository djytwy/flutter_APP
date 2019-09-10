import 'dart:async';
import '../../config/serviceUrl.dart';
import '../ajax.dart';

Future getAllData() async {
  final _data = await baseAjax(
    url:servicePath['workOrderData'],
    params: {
      'label': '0',
    }
  );
  return _data["list"].length;
}

Future getData(workOrderType, pageNum, [userID=false, total=false]) async {
  // workOrderType: 0 新工单 1 我的工单 2 我的报修 3退单处理 4 挂起
  Map<String, dynamic> _params;
  // 新工单和挂起把userId移除掉
  userID == false ? _params = {
    // 'userId': userID.toString(),
    'label': workOrderType.toString(),
    'pageNum': pageNum.toString(),
    'pageSize': "10",
  } : _params = {
    'userId': userID.toString(),
    'label': workOrderType.toString(),
    'pageNum': pageNum.toString(),
    'pageSize': "10",
  };

  // 获取新工单总量
  total ? _params['pageSize'] = '9999' : _params = _params;

  final _data = await baseAjax(
    url:servicePath['workOrderData'],
    // params: params
    params: _params
  );
  if (_data != null) {
    return _data;
  }
}