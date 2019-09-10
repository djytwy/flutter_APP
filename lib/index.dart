import 'package:flutter/material.dart';
import './utils/util.dart';
// 页面
import './pages/home/home.dart';
import './pages/home/scheduling.dart';
import './pages/home/workOrder.dart';
import './pages/home/myTask.dart';
// import 'package:catcher/catcher_plugin.dart';  // 错误捕获
import './pages/reportFix/reportFix.dart';// 报修页面
import './components/Dialog.dart';// 蒙层按钮


class Index extends StatefulWidget {
  Index({Key key}) : super(key: key);
  
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
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
  // 默认 无权限
  bool admin = false; //管理员
  bool repair = true; // 报修
  bool keepInRepair = false; //维修
  bool shiftDutyShow = false; //排班表展示

  @override
  void initState(){
    super.initState();
    setAuthMenu();
  }

  // 根据权限展示菜单
  void setAuthMenu() async {
    Map auth = await getAllAuths();
    setState(() {
      admin = auth['admin'];
      repair = auth['repair'];
      keepInRepair = auth['keepInRepair'];
      shiftDutyShow = auth['shiftDutyShow'];
    });
    List<Map> data = [];
    List<BottomNavigationBarItem> list = [];
    // 报修
    if (auth['repair']) {
      list = [
          BottomNavigationBarItem( icon: Icon(Icons.work), title: Text('工单')),
          BottomNavigationBarItem( icon: Icon(Icons.note_add), title: Text('发起工单')),
          BottomNavigationBarItem( icon: Icon(Icons.track_changes), title: Text('我的任务')),
      ];
      data = [
        { 'name':'工单', 'content': WorkOrder()},
        { 'name':'发起工单', 'content': ''},
        { 'name':'我的任务', 'content': MyTask()},
      ];
      if(auth['repair'] && !auth['keepInRepair'] && !auth['admin']) {
        setState(() {
          _tabIndex = 2;
        });
      }
    }
    // 维修
    if (auth['keepInRepair']) {
      list = [];
      data = [];
      data.add({ 'name':'首页', 'content': Home()});
      list.add(BottomNavigationBarItem( icon: Icon(Icons.home), title: Text('首页')));
      if (shiftDutyShow) {
        data.add({ 'name':'排班', 'content': Scheduing()});
        list.add(BottomNavigationBarItem( icon: Icon(Icons.schedule), title: Text('排班')));
      }
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
      if (!shiftDutyShow) {
        data.removeAt(1);
        list.removeAt(1);
      }
    }
    setState(() {
      _bodys = data;
      _bars = list;
    });
  }
  
  void backHome() {
    // 只有报修权限，点工单的时候，不选返回到我的任务
    if (!admin && repair && !keepInRepair) {
      setState(() {
        _tabIndex = 2;
      });
    } else {
      setState(() {
        _tabIndex = 0;
      });
    } 
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  ShowWorkOrder(CTX.currentState.overlay.context, backHome);
                } else if (_bodys[index]['name'] == '发起工单') {
                  setState(() {
                    _tabIndex = 0;
                  });
                  Navigator.push(CTX.currentState.overlay.context, MaterialPageRoute(
                    builder: (context) => ReportFix(navigatorkeyContext: CTX.currentState.overlay.context)
                  ));
                } else if (_bodys[index]['name'] == '排班') {
                  
                }
              },
              items: _bars
          )
        )
      );
  }
}