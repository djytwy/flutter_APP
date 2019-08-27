import "package:dio/dio.dart";
import 'dart:async';
import '../../config/serviceUrl.dart';
import '../ajax.dart';

Dio dio = Dio();
// 打包的接口：
String baseUrl = serviceUrl;
// 测试的接口：
// String baseUrl = 'http://192.168.5.70:9090/';

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

