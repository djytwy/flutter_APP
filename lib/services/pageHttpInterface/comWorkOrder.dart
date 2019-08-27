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