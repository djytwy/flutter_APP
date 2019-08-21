import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';
import '../config/serviceUrl.dart';

Dio dio = Dio();

Future testGet() async {
  try {
    Response response;
    response = await dio.get(servicePath['testlocal']);
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    return print('ERROR:======>$e');
  }
}
