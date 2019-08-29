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

Future getData(workOrderType, pageNum, [userID=false]) async {
  // workOrderType: 0 新工单 1 我的工单 2 我的报修 3退单处理 4 挂起
  Object _params;
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

  final _data = await baseAjax(
    url:servicePath['workOrderData'],
    // params: params
    params: _params
  );
  if (_data != null) {
    return _data;
  }
}