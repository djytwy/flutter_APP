import 'dart:async';
import '../ajax.dart';
import '../../utils/util.dart';

// 获取班次
Future getOneUserWorkList(params) async {
  var data = await baseAjax(url:'/workorder/userWork/getOneUserWorkList', params: params);
  if (data != null) {
    return data;
  }
}

// 提交排班
Future getShiftDuty(params) async {
  var data = await baseAjax(url:'/workorder/workChange/shiftDuty', params: params, method: 'post');
  if (data != null) {
    showTotast('提交成功！');
    return true;
  }
}

// 排班列表
Future getShiftDutyList(params) async {
  var data = await baseAjax(url:'/workorder/workChange/getAboutUserWorkList', params: params);
  if (data != null) {
    return data;
  }
}
// 排班详情
Future getShiftDutyDetail(params) async {
  var data = await baseAjax(url:'/workorder/workChange/getOneWorkChangInfo', params: params);
  if (data != null) {
    return data;
  }
}
// 处理换班请求
Future getHandleWorkChange(params) async {
  var data = await baseAjax(url:'/workorder/workChange/handleWorkChange', params: params, method: 'post');
  if (data != null) {
    showTotast('操作成功！');
    return true;
  }
}

// 获取排班表列表
Future getAllWorks(params) async {
  var data = await baseAjax(url:'/workorder/userWork/getAllWorkByDate', params: params);
  if (data != null) {
    return data;
  }
}

// 获取排班表列表未读状态
Future getAllWorksStatus(params) async {
  var data = await baseAjax(url:'/systemconfig/appmsg/queryMsgInfos', params: params, method: 'post');
  if (data != null) {
    return data;
  }
}
// 修改排班列表状态改变
Future getChangeWorksStatus(params) async {
  var data = await baseAjax(url:'/systemconfig/appmsg/modfiyMsgInfo', params: params, method: 'post');
  if (data != null) {
    return data;
  }
}


