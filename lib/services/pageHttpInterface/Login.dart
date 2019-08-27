import "package:dio/dio.dart";
import 'dart:async';
import '../../config/serviceUrl.dart';
Dio dio = Dio();

// 测试的接口：
// String baseUrl = 'http://192.168.5.149:8888';
// 打包接口：
String baseUrl = serviceUrl;

Future userLogin(_data) async {
  try {
    Response response;
    var httpHeader = {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Connection': 'keep-alive',
      'Content-Type': 'application/json',
    };
    dio.options.headers = httpHeader;
    response = await dio.post( baseUrl + servicePath['LoginSubmitData'],data:_data);
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    return print('ERROR:======>$e');
  }
}

Future getAuth(_token,_sessionId) async {
  try {
    Response response;
    var httpHeader = {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Connection': 'keep-alive',
      'Content-Type': 'application/json',
      'Authorization': _token,
      'Cookie': _sessionId
    };
    dio.options.headers = httpHeader;
    response = await dio.get(baseUrl + servicePath['getAuthority']);
    if(response.statusCode == 200) {
      Map <String,dynamic> data = response.data;
      var reData = data["datas"];
      return reData;
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    return print('ERROR:======>$e');
  }
}

