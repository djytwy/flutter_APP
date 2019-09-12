import 'package:flutter/foundation.dart';

const serviceUrl= kReleaseMode ? 'https://tesing.china-tillage.com' : 'https://ghhmzjd.tillage-cloud.com:9443';
const servicePath = {
  // 报修相关接口
  'ReportFixData': '/workorder/areaConfig/getTaskAllAreaByTreeName',
  'ReportFixId':'/workorder/areaConfig/getTaskAllAreaByTreeId',
  'ReportFixUser':'/workorder/imsUserInfo/getUserListByDeparmentGai',
  'ReportFixSubmitData': '/workorder/task/sendTask',
   // 登录接口
  'LoginSubmitData': '/systemconfig/app/doLogin',
  'getAuthority': '/systemconfig/app/getLoginInfo',
  // 工单列表相关接口
  'workOrderData': '/workorder/task/getTaskSurvey',
  // 工单内容接口
  'getWorkOrderContent': '/workorder/task/getOneTaskInfo',
  'submitWorkOrder': '/workorder/task/conductTask',
  // 图片上传
  'uploadImg': '/systemconfig/app/upload?module=app&allowFile=jpg|png|gif|jpeg|bmp',
  // 首页
  'getTaskCountByTaskType': '/workorder/task/getTaskCountByTaskType',
  'getOndutyNum': '/workorder/task/getOndutyNum',
  'getFrombyType': '/workorder/task/getFrombyType',
  'getFromByDepartment': '/workorder/task/getFromByDepartment',
  // 获取未读消息的列表
  'unReadMsg': '/systemconfig/appmsg/queryMsgInfos',
  // 修改未读消息为已读
  'changeMsgStatus': '/systemconfig/appmsg/modfiyMsgInfo',
  // 工单页面
  'getTaskInfoList': '/workorder/task/getTaskInfoList',
  'uploadVoice': '/workorder/task/analysisString',
  // 获取抄送人列表
  'getCopierList': '/workorder/imsUserInfo/getUserListByDeparment',
  // 获取默认抄送人
  'getDefaulttCopierList': '/workorder/imsUserInfo/getCopyUserList'
};