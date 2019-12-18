import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'dart:convert';

Widget btn(){
  return RaisedButton(
    padding: EdgeInsets.symmetric(vertical: 12),
    color: Color(0xFF9FFE90),
    onPressed: _send,
    child: Text('点我推送消息'),
  );
}

void _send() async {
  Map data = {"taskState":"1","msgType":"2","title":"测试","msgStatus":"101","taskId":"1","workId":"5d9da72b42dc27fa5a484099"};
  //发送消息类型为1的通知消息，推送内容时输入框输入的内容，延迟推送时间为0（立即推送），附加数据为空
  MobpushPlugin.send(1, '新消息来了', 0, jsonEncode(data)).then((Map<String, dynamic> sendMap){
    String res = sendMap['res'];
    String error = sendMap['error'];
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> send -> res: $res error: $error");
  });
}