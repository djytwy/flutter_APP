import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './services/ServiceLocator.dart';
import './utils/jPush.dart';
import './utils/util.dart';

// 页面
import './index.dart';
// import 'package:catcher/catcher_plugin.dart';  // 错误捕获
import './pages/ModifyPassword.dart';   // 修改密码
import './pages/workOrder/workOrderList.dart';// 退单列表页
import './pages/voiceRecognize/voiceRecognize.dart';// 语音识别页面

void main() {
  // 注册相关服务
  setupLocator();
  // 运行界面
  // CatcherOptions debugOptions =
  //     CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  // CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
  //   EmailManualHandler(["676534074@qq.com"])
  // ]);

  // Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic userId;
  final navigatorkey = GlobalKey<NavigatorState>();
  var jpush = new Jpush.init();

  @override
  void initState(){
    super.initState();
    initData();
    jpush.jpushEventHandler(context);
  }
  // 初始化数据
  void initData() async {
    getLocalStorage('userId').then((_userId) {
      setState(() {
        userId = _userId;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    CTX = navigatorkey;
    return MaterialApp(
      navigatorKey: navigatorkey,
      title: '主页',
      // builder: (BuildContext context, Widget widget) {
      //   Catcher.addDefaultErrorWidget(
      //       showStacktrace: true,
      //       customTitle: "出错了",
      //       customDescription: "未知错误，应用崩溃");
      //   return widget;
      // },
      home: Index(),
      routes: <String, WidgetBuilder> {
        '/submitWorkOrder': (context) => WorkOrderList(userID: userId,workOrderType: "2"),  // 我的工单提交处理，提交了就只能在我的报修中查看
        '/returnBack': (context) => WorkOrderList(userID: userId,workOrderType: "3"),  // 我的工单退单处理，退单了就只能在我的退单中查看
        '/voiceRecognize': (context) => VoicePage(),
        '/modifyPassword': (context) => ModifyPassword()
      },
    );
  }
}