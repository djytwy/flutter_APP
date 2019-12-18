import 'dart:io';
import 'package:app_tims_hotel/pages/Login.dart';
import 'package:app_tims_hotel/pages/home/myTask.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './services/ServiceLocator.dart';

import './utils/jPush.dart'; // 极光推送
import './utils/mobPush.dart'; // mob推送

import './utils/util.dart'; // 工具类

// 页面
import './index.dart';
import './pages/ModifyPassword.dart';   // 修改密码
import './pages/workOrder/workOrderList.dart';// 退单列表页
import './pages/voiceRecognize/voiceRecognize.dart';// 语音识别页面

// 国际化 先默认英文适配
import 'generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // 注册相关服务
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic userId;
  final navigatorkey = GlobalKey<NavigatorState>();
  dynamic jpush = Platform.isIOS ? null : new Jpush.init();

  @override
  void initState(){
    super.initState();
    MobPush().init();   // mobpush插件初始化
    initData();
    if(Platform.isAndroid) jpush.jpushEventHandler(context);
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
      title: '泰立工单管理系统',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeListResolutionCallback: S.delegate.listResolution(
        fallback: const Locale('en',''),
      ),
      home: Index(),
      routes: <String, WidgetBuilder> {
        '/submitWorkOrder': (context) => WorkOrderList(userID: userId,workOrderType: "2"),  // 我的工单提交处理，提交了就只能在我的报修中查看
        '/returnBack': (context) => WorkOrderList(userID: userId,workOrderType: "3"),  // 我的工单退单处理，退单了就只能在我的退单中查看
        '/voiceRecognize': (context) => VoicePage(),
        '/modifyPassword': (context) => ModifyPassword(),
        '/myTask': (context) => MyTask(),
        '/login': (context) => Login(),
      },
    );
  }
}