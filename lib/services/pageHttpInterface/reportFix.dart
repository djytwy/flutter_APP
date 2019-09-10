import 'dart:async';
import '../../config/serviceUrl.dart';
import '../ajax.dart';

Future getData() async {
  final _data = await baseAjax(url:servicePath['ReportFixData']);
  if (_data != null) {
    return _data;
  }
}

Future getPlaceID() async {
  final _data = await baseAjax(url:servicePath['ReportFixId']);
  if (_data != null) {
    return _data;
  }
}

Future getUser() async {
  final _data = await baseAjax(
    url:servicePath['ReportFixUser'],
    params: {"flag": "0"}
  );
  if (_data != null) {
    return _data[0];
  }
}

Future getUserID() async {
  final _data = await baseAjax(
    url:servicePath['ReportFixUser'],
    params: {"flag": "1"}
  );
  if (_data != null) {
    return _data[0];
  }
}

Future postData(_data) async {
  final _returnData = await baseAjax(
    url:servicePath['ReportFixSubmitData'],
    params: _data,
    method: 'post'
  );
  if (_returnData != null) {
    return _data;
  }
}
// 获取抄送人列表
Future getCopierList() async{
  var data = await baseAjax(url: servicePath['getCopierList']);
  if (data != null) {
    return data;
  }
}
// 获取抄送人列表
Future getDefaulttCopierList() async{
  var data = await baseAjax(url: servicePath['getDefaulttCopierList']);
  if (data != null) {
    return data;
  }
}
