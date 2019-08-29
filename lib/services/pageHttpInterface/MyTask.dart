import 'dart:async';
import '../ajax.dart';
import '../../utils/util.dart';

// 获取任务首页 数据
Future getMyTaskList(params) async {
  var data = await baseAjax(url:'/systemconfig/appmsg/queryAppMsgInfoGroup', params: params, method: 'post');
  if (data != null) {
    return data;
  }
}
// 获取工单详情
Future getWorkOrderDetail(params) async {
  var data = await baseAjax(url:'/workorder/task/getOneTaskInfo', params: params);
  if (data != null) {
    return data;
  }
}
// 获取角色列表
Future getRoleList() async {
  var data = await baseAjax(url:'/workorder/imsUserInfo/getRoleList');
  if (data != null) {
    return data;
  }
}
// 派单
Future getdispatchSheet(params) async {
  var data = await baseAjax(url:'/workorder/task/conductTask', params: params, method: 'post');
  if (data != null) {
    showTotast('操作成功！');
    return data;
  }
}
// 用户列表
Future getUserList() async {
  var data = await baseAjax(url:'/workorder/taskTemplate/getUserList');
  if (data != null) {
    return data;
  }
}
// 工单概况
Future getWorkOrderSurvey(params) async {
  var data = await baseAjax(url:'/workorder/task/getTaskListCount', params: params);
  if (data != null) {
    return data;
  }
}
// 根据人获取任务列表
Future getOneUserTaskList(params) async {
  var data = await baseAjax(url:'/workorder/task/getOneUserTaskList', params: params);
  if (data != null) {
    return data;
  }
}
