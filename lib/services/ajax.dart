/**
 * 重构http请求的基类，
 *  参数：
 *    url：请求的url(string)
 *    params：请求参数(object)
 *    method: 请求的方法(string)
 *    headers: 请求头(object)
 *    ps:
 *      生产环境的话将会连接二维码中的URL，开发环境则连接：https://ghhmzjd.tillage-cloud.com:9443
  Update: 2019-11-3
  author: twy
 *
 * */


import "package:dio/dio.dart";
import 'dart:async';
import '../utils/util.dart';
import '../config/serviceUrl.dart';
import '../utils/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio();

Future baseAjax({
  String url, 
  Object params,
  String method,
  Object headers,
  }) async {
    // 读出手机内部的缓存值再次赋值给baseUrl防止程序异常中断后无法登录
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _projectUrl = (prefs.getString('project') ?? null);
    serviceUrl = kReleaseMode ? _projectUrl :'https://ghhmzjd.tillage-cloud.com:9443';
    // serviceUrl = kReleaseMode ? _projectUrl : 'https://tesing.china-tillage.com:543';
    String urls = serviceUrl + url;
  try {
    Response response;
    // 取token
    final val = await getLocalStorage('token');
    if(val != null && val != '') {
      Map<String, dynamic> _headers = {
        "token": val,
        "Authorization": val
      };
      if (headers != null)
      _headers.addAll(headers);
      dio.options.headers = _headers;
    }
    if(!params.toString().contains(', keyWord:')) Loading.show(urls);   // 若有关键词则不显示loading框，优化体验
    if ( method == 'post' || method == 'POST') {
      response = await dio.post(urls, data: params);
    } else {
      response = await dio.get(urls, queryParameters: params );
    }
    if(!params.toString().contains(', keyWord:')) await Loading.cancel(urls);  // 若有关键词则不显示loading框，优化体验
    await Future.delayed(Duration(milliseconds: 200));
    if(response.statusCode == 200 ) {
      Map<String, dynamic> data = response.data;
      if (data['code'] == 2000) {
        return data['datas'];
      } else if(data['code'] == 4003) {
        showTotast('登录失效，请重新登录！');
        signOut();
      } else {
        String _errorString = data['error'];
        showTotast(_errorString);
        return '';
      }
    } else {
      throw Exception('接口出错');
    }
  } catch(e) {
    Loading.cancel(urls);
    showTotast('服务器出错或网络连接失败！');
    return print('ERROR:======>$e  url: $urls 参数：$params');
  }
}

Future upLoadImg({
  String url,
  Object params,
  String method,
  Object headers
}) async{
  try {
    String urls = url;
    Response response;
    Loading.show(urls);
    if ( method == 'post') {
      response = await dio.post(urls, data: params);
    } else {
      response = await dio.get(urls, queryParameters: params );
    }
    await Loading.cancel(urls);
    if(response.statusCode == 200 ) {
      Map<String, dynamic> data = response.data;
      if(data is Map){
        if (data['code'] == 2000) {
          return data['datas'];
        } else {
          return null;
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
    String urls = url;
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