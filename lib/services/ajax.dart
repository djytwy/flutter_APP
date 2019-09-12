import "package:dio/dio.dart";
import 'dart:async';
import '../utils/util.dart';
import '../config/serviceUrl.dart';
import '../utils/loading.dart';
Dio dio = new Dio();

Future baseAjax({
  String url, 
  Object params, 
  String method,
  Object headers,
  }) async{
    // 打包APK的线上URL
    String urls = serviceUrl + url;
    // String urls = 'http://192.168.5.149:8888' + url;
    // String urls = 'http://192.168.5.70:9090' + url;
  try {
    Response response;
    // 取token
    final val = await getLocalStorage('token');
    if(val != null && val != '') {
      Map<String, dynamic> headers = {
        "token": val,
        "Authorization": val
      };
      dio.options.headers = headers;
    } 
    // print(dio.options.headers);
    // dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
    //   // print("请求之前");
    //   // Do something before request is sent
    //   return options; //continue
    // }, onResponse: (Response response) {
    //   print("响应之前");
    //   // print(response.data);
    //   // Do something with response data
    //   return response; // continue
    // }, onError: (DioError e) {
    //   // print("错误之前");
    //   // Do something with response error
    //   return e; //continue
    // }));
    // print(params);
    // print(urls);
    Loading.show(urls);
    if ( method == 'post' || method == 'POST') {
      response = await dio.post(urls, data: params);
    } else {
      response = await dio.get(urls, queryParameters: params );
    }
    Loading.cancel(urls);
    await Future.delayed(Duration(milliseconds: 200));
    if(response.statusCode == 200 ) {
      Map<String, dynamic> data = response.data;
      if (data['code'] == 2000) {
        // print(data['datas']);
        return data['datas'];
      } else if(data['code'] == 4003){
        showTotast('登录失效，请重新登录！');
        signOut();
      }else {
        String _errorString = data['error'];
        showTotast(_errorString);
      }
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    Loading.cancel(urls);
    showTotast('服务器出错或网络连接失败！');
    return print('ERROR:======>$e');
  }
}


Future baseAjax2({
  String url, 
  Object params, 
  String method,
  Object headers
  }) async{
  try {
    // 打包APK的线上URL
    // String urls = serviceUrl + url;
    // String urls = 'http://192.168.5.149:8888' + url;
    String urls = 'http://192.168.5.70:9090' + url;
    Response response;
    if ( method == 'post') {
      response = await dio.post(urls, data: params);
    } else {
      response = await dio.get(urls, queryParameters: params );
    }
    if(response.statusCode == 200 ) {
      Map<String, dynamic> data = response.data;
      if(data is Map){
        if (data['code'] == 2000) {
          return data['datas'];
        } else {
          showTotast(data['error']);
        }
      } else {
        return null;
      }
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    showTotast('服务器出错或网络连接失败！');
    return print('ERROR:======>$e');
  }
}