import '../ajax.dart';
import '../../config/serviceUrl.dart';

/*
  语音识别和消息已读未读的http请求模块
*/ 

// 获取未读的消息列表 
Future unReadMsg(data) async{
  final _data = await baseAjax(
    url: servicePath["unReadMsg"],
    params: data,
    method: 'post'
  );
  if (_data != null) {
    return _data;
  }
}

// 修改未读消息为已读
Future changeMsgStatus(data) async {
  final _data = await baseAjax(
    url: servicePath["changeMsgStatus"],
    params: data,
    method: 'post'
  );
  if (_data != null) {
    return _data;
  }
}

// 将语音识别的结果发送到服务器
Future postVoiceData(data) async {
  final _data = await baseAjax(
    url: servicePath["uploadVoice"],
    params: data,
    method: 'post'
  );
  if (_data != null) {
    return _data;
  }
}
