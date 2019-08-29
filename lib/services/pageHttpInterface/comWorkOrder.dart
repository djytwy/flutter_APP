import '../ajax.dart';
import '../../config/serviceUrl.dart';

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