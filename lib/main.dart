import 'package:flutter/material.dart';
import './services/ServiceLocator.dart';
import './utils/jPush.dart';
// 页面
import './pages/home/home.dart';
import './pages/home/scheduling.dart';
import './pages/home/workOrder.dart';
import './pages/home/myTask.dart';

// 报修页面
import './pages/reportFix/reportFix.dart';

// 退单列表页
import './pages/workOrder/workOrderList.dart';

// 蒙层按钮
import './components/Dialog.dart';

import './utils/util.dart';

void main() {
  // 注册相关服务
  setupLocator();
  // 运行界面
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _tabIndex = 0;
  var tabImages;
  List<Map> _bodys = [
    { 'name':'首页', 'content': Home()},
    { 'name':'我的任务', 'content': MyTask()}
  ];
  List<BottomNavigationBarItem> _bars = [
    BottomNavigationBarItem( icon: Icon(Icons.home), title: Text('首页')),
    BottomNavigationBarItem( icon: Icon(Icons.track_changes), title: Text('我的任务'))
  ];
  var title = [];
  dynamic userId;
  final navigatorkey = GlobalKey<NavigatorState>();
  var jpush = new Jpush.init();


  // 默认 无权限
  bool admin = false; //管理员
  bool repair = true; // 报修
  bool keepInRepair = false; //维修
  @override
  void initState(){
    super.initState();
    initData();
    setAuthMenu();
    jpush.jpushEventHandler(context);
  }
  // 初始化数据
  void initData() async{
    getLocalStorage('userId').then((_userId) {
      setState(() {
        userId = _userId;
      });
    });
  }
  // 根据权限展示菜单
  void setAuthMenu() async{
    Map auth = await getAllAuths();
    setState(() {
      admin = auth['admin'];
      repair = auth['repair'];
      keepInRepair = auth['keepInRepair'];
    });
    List<Map> data = [];
    List<BottomNavigationBarItem> list = [];
    // 报修
    if (auth['repair']) {
      list = [
          BottomNavigationBarItem( icon: Icon(Icons.track_changes), title: Text('我的任务')),
          BottomNavigationBarItem( icon: Icon(Icons.note_add), title: Text('发起工单')),
          BottomNavigationBarItem( icon: Icon(Icons.work), title: Text('工单')),
      ];
      data = [
        { 'name':'我的任务', 'content': MyTask()},
        { 'name':'发起工单', 'content': ''},
        { 'name':'工单', 'content': WorkOrder()},
      ];
    }
    // 维修
    if (auth['keepInRepair']) {
      list = [];
      data = [];
      data.add({ 'name':'首页', 'content': Home()});
      data.add({ 'name':'排班', 'content': Scheduing()});
      list.add(BottomNavigationBarItem( icon: Icon(Icons.home), title: Text('首页')));
      list.add(BottomNavigationBarItem( icon: Icon(Icons.schedule), title: Text('排班')));
      if (repair) {
        data.add({ 'name':'发起工单', 'content': ''});
        list.add(BottomNavigationBarItem( icon: Icon(Icons.note_add), title: Text('发起工单')));
      }
      data.add({ 'name':'工单', 'content': WorkOrder()});
      data.add({ 'name':'我的任务', 'content': MyTask()});
      list.add(BottomNavigationBarItem( icon: Icon(Icons.work), title: Text('工单')));
      list.add(BottomNavigationBarItem( icon: Icon(Icons.track_changes), title: Text('我的任务')));
    }
    // 管理员
    if (auth['admin']) {
      data = [
        { 'name':'首页', 'content': Home()},
        { 'name':'排班', 'content': Scheduing()},
        { 'name':'发起工单', 'content': ''},
        { 'name':'工单', 'content': WorkOrder()},
        { 'name':'我的任务', 'content': MyTask()},
      ];
      list = [
        BottomNavigationBarItem( icon: Icon(Icons.home), title: Text('首页')),
        BottomNavigationBarItem( icon: Icon(Icons.schedule), title: Text('排班')),
        BottomNavigationBarItem( icon: Icon(Icons.note_add), title: Text('发起工单')),
        BottomNavigationBarItem( icon: Icon(Icons.work), title: Text('工单')),
        BottomNavigationBarItem( icon: Icon(Icons.track_changes), title: Text('我的任务'))
      ];
    }
    setState(() {
      _bodys = data;
      _bars = list;
    });
  }
  void backHome() {
    setState(() {
      _tabIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      title: '主页',
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: _bodys[_tabIndex]['content'],
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover
              )
            ),
          ), 
          bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Color.fromRGBO(106, 167, 255, 1), //图标颜色
              backgroundColor: Color.fromRGBO(0, 20, 37, 1), 
              selectedItemColor: Color.fromRGBO(224, 224, 224, 1), //选中的图标颜色
              type: BottomNavigationBarType.fixed,
              currentIndex: _tabIndex,
              onTap: (index) {
                setState(() {
                  if (_tabIndex != index) {
                    _tabIndex = index;
                  }
                });
                if (_bodys[index]['name'] == '工单') {
                  // 选择工单按钮弹出对话框
                  ShowWorkOrder(navigatorkey.currentState.overlay.context, backHome);
                } else if (_bodys[index]['name'] == '发起工单') {
                  setState(() {
                    _tabIndex = 0;
                  });
                  Navigator.push(navigatorkey.currentState.overlay.context, MaterialPageRoute(
                    builder: (context) => ReportFix()
                  ));
                } else if (_bodys[index]['name'] == '排班') {
                  
                }
              },
              items: _bars
          )
        )
      ),
      routes: <String, WidgetBuilder> {
        '/returnBack': (context) => WorkOrderList(userID: userId,workOrderType: "3")
      },
    );
  }
}