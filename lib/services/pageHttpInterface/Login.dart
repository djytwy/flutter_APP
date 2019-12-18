import 'package:app_tims_hotel/utils/util.dart';
import 'dart:async';
import '../../config/serviceUrl.dart';
import '../ajax.dart';


Future userLogin(data) async {
  final _data = await baseAjax(url:servicePath['LoginSubmitData'], params: data, method:'post');
  if (_data != null) return _data;
}

Future getAuth(_token,_sessionId) async {
  var httpHeader = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'zh-CN,zh;q=0.9',
    'Connection': 'keep-alive',
    'Content-Type': 'application/json',
    'Authorization': _token,
    'Cookie': _sessionId
  };
  final _data = await baseAjax(
    url: servicePath['getAuthority'],
    headers: httpHeader
  );
  if(_data != null) return _data;
}
// 修改密码
Future getmodifyPassword(params) async {
  var data = await baseAjax(url: '/systemconfig/users/modifyPassword', params: params, method: 'post');
  if (data != null) {
    showTotast('密码修改成功！');
    return true;
  }
}
// 发送设备id
Future getSendRegistId(params) async {
  print('推送设备ID参数：$params');
  await baseAjax(url: '/systemconfig/users/registJpush', params: params, method: 'post');
}
// 退出
Future loginOut() async {
  print('退出');
  await baseAjax(url: servicePath["loginOut"]);
}
