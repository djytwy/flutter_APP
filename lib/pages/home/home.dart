import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/Login.dart';
import '../../services/pageHttpInterface/home.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import '../../utils/util.dart';
import '../../pages/workOrder/inTimeWorkOrder.dart';
import '../ModifyPassword.dart';
import '../../utils/eventBus.dart';

const String MIN_DATETIME = '2010-05-12';
const String MAX_DATETIME = '2021-11-25';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 选择下拉菜单
  List<DropdownMenuItem> getListData(){
    List<DropdownMenuItem> items=new List();
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('按年筛选'),
      value: '1',
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text('按月筛选'),
      value: '2',
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text('按天筛选'),
      value: '3',
    );
    items.add(dropdownMenuItem3);
    return items;
  }
  var value;
  bool _work = false; //工单
  bool _showTitle = true;

  bool animate;
  List<Widget> widgetList = List();

  DateTimePickerLocale _locale = DateTimePickerLocale.zh_cn;
  // List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  String _format = 'yyyy';
  // TextEditingController _formatCtrl = TextEditingController();

  DateTime _dateTime;
  // 用户信息
  String _token = '';
  String _menus = '';
  String _userName = '';
  String _postName = '';
  String _departmentName = '';
  String _phoneNum = '';
  String _userId = '';
  // 工单总数信息
  int _orderAll = 0;
  int _orderNo = 0;
  String _orderLabel = '';
  String _orderHas = '';
  // 巡检/维保总数信息
  int _siteAll = 0;
  int _siteNo = 0;
  String _siteLabel = '';
  String _siteHas = '';
  // 当前在岗人数
  int _currentPeopleNum = 0;
  // 工单来源的数据
  int _orderSourceAll = 0;
  List _orderData = [];
  // 即时工单的数据
  int _currentOrderAll = 0;
  List _currentOrderData = [];

  // 版本号
  String _version;

  @override
  void initState() {
    super.initState();
    _initUserInfo();
    //监听访问详情事件，来刷新通知消息
    bus.on("refreshHome", (arg) {
      _initUserInfo();
   });
  }
  @override
    void dispose() {
      super.dispose();
      bus.off("refreshHome");//移除广播监听
  }
  _initUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? '');
    });
    if (_token != '') {
      setState(() {
        _menus = (prefs.getString('authMenus') ?? '');
        _userName = (prefs.getString('userName') ?? '');
        _postName = (prefs.getString('postName') ?? '');
        _departmentName = (prefs.getString('departmentName') ?? '');
        _phoneNum = (prefs.getString('phoneNum') ?? '');
        _userId = (prefs.getString('userId') ?? '');
        if (_menus.indexOf('50') != -1) {
          setState(() {
            _userId = '-1';
          });
        }
      });
      final nowDay = DateTime.now();
      var nowData = nowDay.toString().substring(0,10);
      getTaskCountByTaskType(_token,_userId,nowData);
      getCurrentPeople(_token,nowData);
      getOrderData(_token,_userId,nowData);
      getCurrentOrderData(_token,_userId,nowData);
      // 初始化版本号
      _genVersion();
    } else {
      showTotast('您还未登录,1秒之后将跳转到登录页面','center');
      const timeout = const Duration(seconds: 1);
      Timer(timeout, () {
      //到时回调
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => new Test(
          )
        ));
      });
    }
  }
  // 获取及时工单和巡检/维保的数据
  void getTaskCountByTaskType(token,userId,date) {
    getTaskCount(token,userId,date).then((val) {
      setState(() {
        _orderLabel = val[0]['label'];
        _orderAll = val[0]['zong'];
        _orderNo = val[0]['wei'];
        _orderHas = val[0]['lv'];
        _siteLabel = val[1]['label'];
        _siteAll = val[1]['zong'];
        _siteNo = val[1]['wei'];
        _siteHas = val[1]['lv'];
      });
      print(_orderLabel);
    });
  }
  // 获取当前在岗人数的数据
  void getCurrentPeople(token,date) {
    getCountPeople(token,date).then((val) {
      setState(() {
        _currentPeopleNum = val;
      });
    });
  }
  // 获取工单来源的数据
  void getOrderData(token,userId,date) {
    getOrderSource(token,userId,date).then((val) {
      print(val);
      setState(() {
        _orderSourceAll = val['taskCount'];
        _orderData = val['info'];
      });
    });
  }
  // 获取即时工单的数据
  void getCurrentOrderData(token,userId,date) {
    getCurrentOrder(token,userId,date).then((val) {
      print(val);
      setState(() {
        _currentOrderAll = val['taskCount'];
        _currentOrderData = val['info'];
      });
    });
  }
  void signOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('menus');
    prefs.remove('userName');
    prefs.remove('postName');
    prefs.remove('userId');
    prefs.remove('departmentName');
    prefs.remove('phoneNum');
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => new Test(
      )
    ));
  }
  // 下面的_showDatePicker是需求变更了，暂时注释，勿删！
  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: _showTitle,
        confirm: Text('确认', style: TextStyle(color: Colors.red)),
        cancel: Text('取消', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
        if (_format == 'yyyy') {
          var year = _dateTime.toString().substring(0,4);
          print(year);
          getTaskCountByTaskType(_token,_userId,year);
          getOrderData(_token,_userId,year);
          getCurrentOrderData(_token,_userId,year);
        } else if (_format == 'yyyy-MMMM') {
          var mounth = _dateTime.toString().substring(0,7);
          getTaskCountByTaskType(_token,_userId,mounth);
          getOrderData(_token,_userId,mounth);
          getCurrentOrderData(_token,_userId,mounth);
          print(mounth);
        } else if (_format == 'yyyy-MMMM-dd') {
          var day = _dateTime.toString().substring(0,10);
          getTaskCountByTaskType(_token,_userId,day);
          getOrderData(_token,_userId,day);
          getCurrentOrderData(_token,_userId,day);
        }
      },
    );
  }
  
  // 生成版本号
  void _genVersion() {
    DateTime now = DateTime.now();
    dynamic version = (now.day + 10).toString();
    dynamic year = (now.year).toString();
    dynamic month = (now.month).toString();
    dynamic day = (now.day).toString();
    setState(() {
      _version = '0.0.$version _ $year$month$day';
    });
  }
  Widget build(BuildContext context) {
    // 图表1的数据信息
    var data = [
      new ClicksPerYear('2016', 12, Colors.red),
    ];
    data.removeLast();
    for (var item in _orderData) {
      data.add(new ClicksPerYear(item['label'], item['num'], Color.fromRGBO(106, 167, 255, 1)));
    }
    var series = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];
    
    var chart = new charts.BarChart(
      series,
      animate: true,
      primaryMeasureAxis:
        new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.only(right: 16.0,left: 16.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    // 图表2的数据信息
    var data2 = [
      new ClicksPerYear('2016', 12, Colors.red),
    ];
    data2.removeLast();
    for (var item in _currentOrderData) {
      data2.add(new ClicksPerYear(item['label'], item['num'], Color.fromRGBO(106, 167, 255, 1)));
    }
    var series2 = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data2,
      ),
    ];
    var chart2 = new charts.BarChart(
      series2,
      animate: true,
      primaryMeasureAxis:    // 显示基础图表，莫得线
        new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
    var chartWidget2 = new Padding(
      padding: new EdgeInsets.only(right: 16.0,left: 16.0),
      child: new SizedBox(
        height: 200.0,
        child: chart2,
      ),
    );
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667, allowFontScaling: true)..init(context);
    Widget header = DrawerHeader(
      padding: EdgeInsets.zero, /* padding置为0 */
      child: new Stack(children: <Widget>[ /* 用stack来放背景图片 */
        // new Image.asset(
        //   'assets/images/background.png', fit: BoxFit.fill, width: double.infinity,),
        new Align(/* 先放置对齐 */
          alignment: FractionalOffset.center,
          child: Container(
            // height: 100.0,
            width: setWidth(100),
            margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min, /* 宽度只用包住子组件即可 */
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: Center(
                    child: new CircleAvatar(
                    backgroundImage: AssetImage('assets/images/LOGO.png'),
                    radius: 35.0,),
                    ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: new Text(this._userName, style: new TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),),
                  )
                ),
              ],),
          ),
        ),
      ]),);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: setWidth(95)),
                child: Text('首页',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(16))),
              )
              // 暂时隐藏时间控件
              // Expanded(
              //   child: Center(
              //     child: Text('首页',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(16))),
              //   ),
              // ),
              // Expanded(
              //   flex: 0,
              //   child: new DropdownButton(
              //     items: getListData(),
              //     hint:new Text('选择时间',style: TextStyle(color: Color(0xFFff0000)),),//当没有默认值的时候可以设置的提示
              //     value: value,//下拉菜单选择完之后显示给用户的值
              //     onChanged: (T){//下拉菜单item点击之后的回调
              //       print(T);
              //       if (T == '1') {
              //         setState(() {
              //           _format = 'yyyy';
              //         });
              //         this._showDatePicker();
              //       } else if (T == '2') {
              //         setState(() {
              //           _format = 'yyyy-MMMM';
              //         });
              //         this._showDatePicker();
              //       } else if (T == '3') {
              //         setState(() {
              //           _format = 'yyyy-MMMM-dd';
              //         });
              //         this._showDatePicker();
              //       }
              //       setState(() {
              //         value=T;
              //       });
              //     },
              //     elevation: 24,//设置阴影的高度
              //     style: new TextStyle(//设置文本框里面文字的样式
              //       color: Colors.red
              //     ),
              //      // isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
              //     iconSize: 20.0,//设置三角标icon的大小
              //   ),
              // )
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent
      ),
      drawer: new Drawer(
        child: new Container(
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover
            )
          ),
          child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            header,  // 上面是自定义的header
            ListTile(
              title: Container(
                margin: EdgeInsets.only(left: setHeight(10),right: setHeight(10),top: setHeight(20),bottom: setHeight(10)),
                color: Color.fromRGBO(4, 38, 83, 0.35),
                height: setHeight(45),
                child: Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(left: setHeight(10),right: setHeight(10)),
                      child: new Text('部门',style: TextStyle(color: Color(0xFF999999),fontSize: setFontSize(16))),
                    ),
                     new Padding(
                      padding: EdgeInsets.only(left: setHeight(10),right: setHeight(10)),
                      child: new Text(this._departmentName,style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(16))),
                    )
                  ],
                )
              ),
              enabled: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Container(
                margin: EdgeInsets.only(left: setHeight(10),right: setHeight(10),bottom: setHeight(10)),
                color: Color.fromRGBO(4, 38, 83, 0.35),
                height: setHeight(45),
                child: Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(left: setHeight(10),right: setHeight(10)),
                      child: new Text('电话',style: TextStyle(color: Color(0xFF999999),fontSize: setFontSize(16))),
                    ),
                     new Padding(
                      padding: EdgeInsets.only(left: setHeight(10),right: setHeight(10)),
                      child: new Text(this._phoneNum,style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(16))),
                    )
                  ],
                )
              ),
              enabled: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Container(
                margin: EdgeInsets.only(left: setHeight(10),right: setHeight(10),bottom: setHeight(10)),
                color: Color.fromRGBO(4, 38, 83, 0.35),
                height: setHeight(45),
                child: Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(left: setHeight(10),right: setHeight(10)),
                      child: new Text('职位',style: TextStyle(color: Color(0xFF999999),fontSize: setFontSize(16))),
                    ),
                     new Padding(
                      padding: EdgeInsets.only(left: setHeight(10),right: setHeight(10)),
                      child: new Text(this._postName,style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(16))),
                    )
                  ],
                )
              ),
              enabled: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => new ModifyPassword()
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(left: setHeight(10),right: setHeight(10),bottom: setHeight(10)),
                  color: Color.fromRGBO(4, 38, 83, 0.35),
                  height: setHeight(45),
                  child: Row(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(left: setHeight(10),right: setHeight(10)),
                        child: new Text('修改密码',style: TextStyle(color: Color(0xFF999999),fontSize: setFontSize(16))),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: setHeight(100)),
                        child: Icon(Icons.keyboard_arrow_right,color: Color(0xFF999999),),
                      )
                    ],
                  )
                ),
              )
            ),
            ListTile(
              title: GestureDetector(
                 onTap: signOut,
                 child: Container(
                    margin: EdgeInsets.only(left: setHeight(10),right: setHeight(10),top: setHeight(90)),
                    color: Color.fromRGBO(4, 38, 83, 0.35),
                    height: setHeight(45),
                    child: new Center(
                      child: new Text('退出登录',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(16))),
                    )
                  ),
              )
             ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(160)),
              child: kReleaseMode ? Text('正式版本号: $_version',style:TextStyle(color:Colors.white54)) : Text('debug 版本号: $_version',style:TextStyle(color:Colors.white54)),
            )
          ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover
          )
        ),
        child: new SingleChildScrollView(
          child: Container(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //居左
              children: <Widget>[
                Offstage(
                  offstage: this._work,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: setHeight(72),
                          color: Color.fromRGBO(4, 38, 83, 0.35),
                          margin: EdgeInsets.only(top: setHeight(10)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: setHeight(48),
                                  child: GestureDetector(
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: GestureDetector(
                                                child: Center(
                                                  // child: Icon(Icons.people,color: Color.fromRGBO(106, 167, 255, 1),)
                                                  child: Image.asset('assets/images/people.png'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: GestureDetector(
                                                child: Center(
                                                  child: Text('当前在岗人数', style: TextStyle(color: Color(0xFFffffff), fontSize: setFontSize(14)),),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width: setWidth(1),
                                  height: setHeight(44),
                                  color: Color.fromRGBO(76, 135, 179, 1),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(this._currentPeopleNum.toString(), style: TextStyle(color: Color.fromRGBO(106, 167, 255, 1), fontSize: setFontSize(60)),),
                                  )
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: setHeight(90),
                          color: Color.fromRGBO(4, 38, 83, 0.35),
                          margin: EdgeInsets.only(top: setHeight(10)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Center(
                                            // child: Icon(Icons.people,color: Color.fromRGBO(106, 167, 255, 1),size: 40,),
                                            child: Image.asset('assets/images/now.png',width: setWidth(54),height: setHeight(54),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    child: Center(
                                                      child: Text(this._orderAll.toString(),style: TextStyle(color: Color(0xFF81E2E7),fontSize:  setFontSize(40))),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Center(
                                                      child: Text(this._orderLabel,style: TextStyle(color: Color(0xFFffffff),fontSize:  setFontSize(14))),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Container(
                                          width: setWidth(1),
                                          height: setHeight(80),
                                          margin: EdgeInsets.only(right: setHeight(5)),
                                          color: Color(0xFF010D1D),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Container(
                                          width: setWidth(120),
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                       new Center(
                                                          child: new Text('未完成数:',style: TextStyle(color: Color(0XFFffffff),fontSize: setFontSize(14)),),
                                                        ),
                                                        new Padding(
                                                          padding: new EdgeInsets.only(left: 8.0,top: 4.0),
                                                          child: new Text(this._orderNo.toString(),style: TextStyle(color: Color(0XFFff5500),fontSize: setFontSize(14)),),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        new Center(
                                                          child: new Text('已完成率:',style: TextStyle(color: Color(0XFFffffff),fontSize: setFontSize(14)),),
                                                        ),
                                                        new Padding(
                                                          padding: new EdgeInsets.only(left: 8.0,top: 4.0),
                                                          child: new Text(this._orderHas,style: TextStyle(color: Color(0XFF00FF00),fontSize: setFontSize(14)),),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Container(
                                          width: setWidth(20),
                                          margin: EdgeInsets.only(right: setHeight(20)),
                                          child: Center(
                                            child: new IconButton(
                                              icon: Icon(Icons.keyboard_arrow_right,color: Color(0xFFffffff),),
                                              onPressed: () {
                                                print(this._token);
                                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => InTimeWorkOrder(taskType:"0")
                                                ));
                                              },
                                            )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],),
                        ),
                        Container(
                          height: setHeight(90),
                          color: Color.fromRGBO(4, 38, 83, 0.35),
                          margin: EdgeInsets.only(top: setHeight(10)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Center(
                                            // child: Icon(Icons.people,color: Color.fromRGBO(106, 167, 255, 1),size: 40,),
                                            child: Image.asset('assets/images/bao.png',width: setWidth(54),height: setHeight(54),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    child: Center(
                                                      child: Text(this._siteAll.toString(),style: TextStyle(color: Color(0xFF81E2E7),fontSize:  setFontSize(40))),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Center(
                                                      child: Text(this._siteLabel,style: TextStyle(color: Color(0xFFffffff),fontSize:  setFontSize(14))),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Container(
                                          width: setWidth(1),
                                          height: setHeight(80),
                                          margin: EdgeInsets.only(right: setHeight(5)),
                                          color: Color(0xFF010D1D),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Container(
                                          width: setWidth(120),
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        new Center(
                                                          child: new Text('未完成数:',style: TextStyle(color: Color(0XFFffffff),fontSize: setFontSize(14)),),
                                                        ),
                                                        new Padding(
                                                          padding: new EdgeInsets.only(left: 8.0,top: 4.0),
                                                          child: new Text(this._siteNo.toString(),style: TextStyle(color: Color(0XFFff5500),fontSize: setFontSize(14)),),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        new Center(
                                                          child: new Text('已完成率:',style: TextStyle(color: Color(0XFFffffff),fontSize: setFontSize(14)),),
                                                        ),
                                                        new Padding(
                                                          padding: new EdgeInsets.only(left: 8.0,top: 4.0),
                                                          child: new Text(this._siteHas,style: TextStyle(color: Color(0XFF00FF00),fontSize: setFontSize(14)),),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Container(
                                          width: setWidth(20),
                                          margin: EdgeInsets.only(right: setHeight(20)),
                                          child: Center(
                                            child: new IconButton(
                                              icon: Icon(Icons.keyboard_arrow_right,color: Color(0XFFffffff),),
                                              onPressed: () {
                                                print('我要跳到哪');
                                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => InTimeWorkOrder(taskType:"1")
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],),
                        ),
                        Container(
                          color: Color.fromRGBO(4, 38, 83, 0.35),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.only(left: 16.0),
                                    child: Text('工单来源   |   总数:',style: TextStyle(color: Color(0xFFffffff)),),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.only(top: 4.0,left: 8.0),
                                    child: Center(child: Text(this._orderSourceAll.toString(),style: TextStyle(color: Color(0xFF0099FF)),)),
                                  )
                                ],
                              ),
                              chartWidget,
                            ],
                          ),
                        ),
                        Container(
                          color: Color.fromRGBO(4, 38, 83, 0.35),
                          margin: new EdgeInsets.only(top: 16.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.only(left: 16.0),
                                    child: Text('即时工单   |   总数:',style: TextStyle(color: Color(0xFFffffff)),),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.only(top: 4.0,left: 8.0),
                                    child: Center(child: Text(this._currentOrderAll.toString(),style: TextStyle(color: Color(0xFF0099FF)),)),
                                  )
                                ],
                              ),
                              chartWidget2,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ), 
      ),
      )
          ),
        ],
      )
    );
  }
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
// 设置宽度
setWidth(double n){
  return ScreenUtil().setWidth(n);
}
// 设置高度
setHeight(double n){
  return ScreenUtil().setHeight(n);
}
// 设置字体大小
setFontSize(double n){
  return ScreenUtil(allowFontScaling: true).setSp(n);
}
// 设置 四个方向的 margin
setMargin(double n){
  return EdgeInsets.only(left: setWidth(n), right: setWidth(n), top: setHeight(n), bottom: setHeight(n));
}