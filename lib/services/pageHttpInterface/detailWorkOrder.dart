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
