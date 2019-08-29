import "package:dio/dio.dart";
import 'dart:async';
import '../../config/serviceUrl.dart';
import '../ajax.dart';
import 'dart:io';

Future getData(taskID,userID) async {
  final _data = await baseAjax(
    url:servicePath['getWorkOrderContent'],
    params: {
      'taskId': taskID,
      'userId': userID
    }
  );
  if (_data != null) {
    return _data;
  }
}

Future uploadImg(imgfile) async {
  String path = imgfile.path;
  var name = path.substring(path.lastIndexOf("/") + 1, path.length);
  FormData formData =  FormData.from({
    "fileName":  UploadFileInfo(File(path), name)
  });
  final _data = await baseAjax(
    url: servicePath["uploadImg"],
    params: formData,
    method: 'post'
  );
  if (_data != null) {
    return _data;
  }
}

Future submitData(data) async {
  final _data = await baseAjax(
    url: servicePath["submitWorkOrder"],
    params: data,
    method: 'post'
  );
  if (_data != null) {
    return _data;
  }
}

Future returnBack(data) async {
  final _data = await baseAjax(
    url: servicePath["submitWorkOrder"],
    params: data,
    method: 'post'
  );
  if (_data != null) {
    return _data;
  }
}