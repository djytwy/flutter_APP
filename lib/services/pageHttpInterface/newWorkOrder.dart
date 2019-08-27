import "package:dio/dio.dart";
import 'dart:async';
import '../../config/serviceUrl.dart';

Dio dio = Dio();
// 打包的接口：
String baseUrl = serviceUrl;
// 测试的接口：
// String baseUrl = 'http://192.168.5.70:9090/';

const httpHeader = {
  'Accept': 'application/json, text/plain, */*',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'zh-CN,zh;q=0.9',
  'Connection': 'keep-alive',
  'Content-Type': 'application/json',
};

Future getData(int pageNum) async {
  try {
    Response response;
    dio.options.headers = httpHeader;
    response = await dio.get(
      baseUrl + servicePath['NewWorkOrderData'],
      queryParameters: {
        "label": "0",
        "pageNum": '$pageNum',
        "pageSize": "10"
      }
    );
    if(response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      final reData = data["datas"]["list"];
      final total = data["datas"]["total"];
      return {'data':reData, 'total':total};
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    return print('ERROR:======>$e');
  }
}

Future getPlaceID() async {
  try {
    Response response;
    response = await dio.get(baseUrl + servicePath['ReportFixId']);
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

Future getUser() async {
  try {
    Response response;
    response = await dio.get(
      baseUrl + servicePath['ReportFixUser'],
      queryParameters: {
        "flag": "0"
      }
    );
    if(response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      var reData = data["datas"];
      return reData[0];
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    return print('ERROR:======>$e');
  }
}

Future getUserID() async {
  try {
    Response response;
    response = await dio.get(
      baseUrl + servicePath['ReportFixUser'],
      queryParameters: {
        "flag": "1"
      }
    );
    if(response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      var reData = data["datas"];
      return reData[0];
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    return print('ERROR:======>$e');
  }
}

Future postData(_data) async {
  try {
    Response response;
    dio.options.headers = httpHeader;
    response = await dio.post(baseUrl + servicePath['ReportFixSubmitData'],data:_data);
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    return print('ERROR:======>$e');
  }
}

