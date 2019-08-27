import "package:dio/dio.dart";
import 'dart:async';
import '../../config/serviceUrl.dart';
Dio dio = Dio();

// 测试的接口：
String baseUrl = 'http://192.168.5.70:9090';
// 打包接口：
// String baseUrl = serviceUrl;
// 获取及时工单和巡检/维保的数据
Future getTaskCount(token,userId,date) async {
  try {
    Response response;
    var httpHeader = {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Connection': 'keep-alive',
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    dio.options.headers = httpHeader;
    response = await dio.get(baseUrl + servicePath['getTaskCountByTaskType'],queryParameters: {'dateString':date,'userId':userId});
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
// 获取当前在岗人数的数据
Future getCountPeople(token,date) async {
  try {
    Response response;
    var httpHeader = {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Connection': 'keep-alive',
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    dio.options.headers = httpHeader;
    response = await dio.get(baseUrl + servicePath['getOndutyNum'],queryParameters: {'dateString':date});
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
// 获取工单来源的数据
Future getOrderSource(token,userId,date) async {
  try {
    Response response;
    var httpHeader = {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Connection': 'keep-alive',
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    dio.options.headers = httpHeader;
    response = await dio.get(baseUrl + servicePath['getFrombyType'],queryParameters: {'dateString':date,'userId':userId});
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
// 获取即时工单的数据
Future getCurrentOrder(token,userId,date) async {
  try {
    Response response;
    var httpHeader = {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Connection': 'keep-alive',
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    dio.options.headers = httpHeader;
    response = await dio.get(baseUrl + servicePath['getFromByDepartment'],queryParameters: {'dateString':date,'userId':userId});
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

