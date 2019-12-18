/**
 * 获取抄送人的HTTP服务
 * author: djytwy on 2019-11-18 10:49
 */

import '../../config/serviceUrl.dart';
import '../ajax.dart';

// 获取抄送人列表
Future getCopierList() async{
  var data = await baseAjax(url: servicePath['getCopierList']);
  if (data != null) {
    return data;
  }
}
// 获取抄送人列表
Future getDefaulttCopierList() async{
  var data = await baseAjax(url: servicePath['getDefaulttCopierList']);
  if (data != null) {
    return data;
  }
}