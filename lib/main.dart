import 'package:flutter/material.dart';
import './services/ServiceLocator.dart';

// 页面
import './pages/home/home.dart';
import './pages/home/scheduling.dart';
import './pages/home/workOrder.dart';
import './pages/home/myTask.dart';

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
  var _bodys = [];
  var appBarTitles = ['首页', '排班', '工单', '我的任务'];
  void initData(){
    _bodys = [
      new Home(),
      new Schdeuling(),
      new WorkOrder(),
      new MyTask(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    initData();
    return MaterialApp(
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
            child: _bodys[_tabIndex],
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover
              )
            ),
          ),
          // appBar: AppBar(
          //   title: Text(appBarTitles[_tabIndex], style: TextStyle(fontSize: 18),),
          //   centerTitle: true,
          //   backgroundColor: Colors.transparent
          // ),
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
              },
              items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('首页')
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.schedule),
                    title: Text('排班')
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work),
                    title: Text('工单')
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.track_changes),
                    title: Text('我的任务')
                  )
              ]
          )
        )
      )
    );
  }
}