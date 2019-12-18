import 'package:app_tims_hotel/pages/barcodeScan/barcodeScan.dart';
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
import '../../utils/eventBus.dart';
import 'view/drawerPage.dart';
import 'view/BottomSheet.dart';
import '../../services/pageHttpInterface/Login.dart';

const String MIN_DATETIME = '2010-05-12';
const String MAX_DATETIME = '2099-11-25';

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
  String _project; // 项目关联的数据库
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
  // 项目信息
  String _projectName = '';
  String Online = '0';
  String Outline = '0';
  List peopleData = [
    {
      'label': '暂无人员',
      'children': [
      ]
    },
  ];


  @override
  void initState() {
    super.initState();
    _initUserInfo();
    // 获取当前在线、离线人数
    getOnlineOutline();
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

  // 获取在线的人数和离线的人数
  Future<void> getOnlineOutline() async {
    List _test1 = List.generate(10, (e) => {
      "classificationName": "落魄前端在线炒饭部",
      "userCode": "123",
      "userName": "炒饭$e号",
      "parentName": "无所谓",
      "online": e%2 == 0?  "online" : "outline"
    });
    List _test2 = List.generate(10, (e) => {
      "classificationName": "落魄Java在线炒粉部",
      "userCode": "123",
      "userName": "炒粉$e号",
      "parentName": "无所谓",
      "online": e%2 == 0?  "online" : "outline"
    });
//    Map _data = {
//      "onlineCount": '10',
//      "offlineCount": '20',
//      "onDutyOnlineUserList": [
//        ..._test1, ..._test2
//      ]
//    };
    Map _data = await toGetOnlineOutline();
    // 组装好返回的数据
    List _tempData = [];
    // 已经添加过的部门
    List addedClassify = [];

    if(_data!= null && _data["onDutyOnlineUserList"].length > 0) {
      for (var _index in _data["onDutyOnlineUserList"]) {
        if (!addedClassify.contains(_index["classificationName"])) {
          _tempData.add({
            'label': _index["classificationName"],
            'children': [{
              'label': _index["userName"],
              'status': _index["online"] == 'online' ? 1 : 2,
              'children': []
            }]
          });
          addedClassify.add(_index["classificationName"]);
        } else {
          _tempData.forEach((e) {
            if (e["label"] == _index["classificationName"]) {
              e["children"].add({
                'label': _index["userName"],
                'status': _index["online"] == 'online' ? 1 : 2,
                'children': []
              });
            }
          });
        }
      }

      setState(() {
        Online = _data['onlineCount'].toString();
        Outline = _data['offlineCount'].toString();
        peopleData = _tempData;
      });
    }
  }

  _initUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // debug模式进入调试版本
      _project = kReleaseMode ? (prefs.getString('project') ?? null) : '调试版本';
      _token = (prefs.getString('token') ?? '');
    });
    if (_token != '' && _project != null) {
      setState(() {
        _menus = (prefs.getString('authMenus') ?? '');
        _userName = (prefs.getString('userName') ?? '');
        _postName = (prefs.getString('postName') ?? '');
        _departmentName = (prefs.getString('departmentName') ?? '');
        _phoneNum = (prefs.getString('phoneNum') ?? '');
        _userId = (prefs.getString('userId') ?? '');
        _projectName = (prefs.getString('projectName') ?? '');
        if (_menus.indexOf('50') != -1) {
          setState(() {
            _userId = '-1';
          });
        }
      });

      getTaskCountByTaskType(_token,_userId);
      getCurrentPeople(_token);
      getOrderData(_token,_userId);
      getCurrentOrderData(_token,_userId);
    } else if (_token == '' && _project != null) {
      showTotast('您还未登录,1秒之后将跳转到登录页面','center');
      const timeout = const Duration(seconds: 1);
      Timer(timeout, () {
      //到时回调
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Login()
        ));
      });
    } else {
      showTotast('您还未进行手机绑定，1秒后跳转到手机绑定页');
      await Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => BarcodeScan()
        ));
      });
    }
  }
  // 获取即时工单和巡检/维保的数据
  void getTaskCountByTaskType(token,userId) {
    getTaskCount(token,userId).then((val) {
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
    });
  }
  // 获取当前在岗人数的数据
  void getCurrentPeople(token) {
    getCountPeople(token).then((val) {
      setState(() {
        _currentPeopleNum = val;
      });
    });
  }
  // 获取工单来源的数据
  void getOrderData(token,userId) {
    getOrderSource(token,userId).then((val) {
      print(val);
      setState(() {
        _orderSourceAll = val['taskCount'];
        _orderData = val['info'];
      });
    });
  }
  // 获取即时工单的数据
  void getCurrentOrderData(token,userId) {
    getCurrentOrder(token,userId).then((val) {
      print(val);
      setState(() {
        _currentOrderAll = val['taskCount'];
        _currentOrderData = val['info'];
      });
    });
  }

  // 判断图表数据的长度是否大于4，若小于4，则补到4,用于图表渲染占位
  List<ClicksPerYear> handleChartData(data) {
    if(data.length < 4) {
      Map stringMap = {0:'',1:'  ',2:'   ',3:'    '};
      int loopNum = 4-data.length;
      for (int _index = 0; _index<loopNum; _index++) {
        String _labelTemp = stringMap[_index];
        data.add(ClicksPerYear(_labelTemp, 0, Colors.blue),);
      }
    }
    return data;
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('menus');
    prefs.remove('userName');
    prefs.remove('postName');
    prefs.remove('userId');
    prefs.remove('departmentName');
    prefs.remove('phoneNum');
    // 调用一次登出的接口
    await loginOut();
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => new Login()
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
          getTaskCountByTaskType(_token,_userId);
          getOrderData(_token,_userId);
          getCurrentOrderData(_token,_userId);
        } else if (_format == 'yyyy-MMMM') {
          var mounth = _dateTime.toString().substring(0,7);
          getTaskCountByTaskType(_token,_userId);
          getOrderData(_token,_userId);
          getCurrentOrderData(_token,_userId);
          print(mounth);
        } else if (_format == 'yyyy-MMMM-dd') {
          var day = _dateTime.toString().substring(0,10);
          getTaskCountByTaskType(_token,_userId);
          getOrderData(_token,_userId);
          getCurrentOrderData(_token,_userId);
        }
      },
    );
  }

  Widget build(BuildContext context) {
    // 图表1的数据信息
    List<ClicksPerYear> data = [];
    for (var item in _orderData) {
      data.add(new ClicksPerYear(item['label'], item['num'], Color.fromARGB(255, 74, 144, 226)));
    }
    data = handleChartData(data);
    var series = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
        labelAccessorFn: (ClicksPerYear clickData, _) => '${clickData.clicks}'
      ),
    ];
    
    var chart = new charts.BarChart(
      series,
      animate: true,
      domainAxis: charts.OrdinalAxisSpec(
        // 初始化显示4个条状图，配合
        viewport: charts.OrdinalViewport('', 4),
        // 显示标签文字的style
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.Color.white
          )
        )
      ),
      // 使用基础度量单位，没有基础参考线
      primaryMeasureAxis: charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      // 可缩放
      behaviors: [charts.PanAndZoomBehavior()],
      // 条状图头上的label样式
      barRendererDecorator: charts.BarLabelDecorator<String>(
        outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.white),
        labelPosition: charts.BarLabelPosition.outside
      ),
    );
    var orderFrom = new Padding(
      padding: new EdgeInsets.only(right: 0.5,left: 0.5),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    // 图表2的数据信息
    List<ClicksPerYear> data2 = [];
    for (var item in _currentOrderData) {
      data2.add(ClicksPerYear(item['label'], item['num'], Color.fromARGB(255, 74, 144, 226)));
    }
    data2 = handleChartData(data2);
    var series2 = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data2,
        labelAccessorFn: (ClicksPerYear clickData, _) => '${clickData.clicks}'
      ),
    ];
    var chart2 = new charts.BarChart(
      series2,
      animate: true,
      // 显示基础图表，莫得线
      primaryMeasureAxis: charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      domainAxis: charts.OrdinalAxisSpec(
        // 初始化显示3个条状图
        viewport: charts.OrdinalViewport('', 4),
        // 显示标签文字的style
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.Color.white
          )
        )
      ),
      // 可缩放
      behaviors: [charts.PanAndZoomBehavior()],
      // bar顶上的label样式
      barRendererDecorator: charts.BarLabelDecorator<String>(
        outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.white),
        labelPosition: charts.BarLabelPosition.outside
      ),
    );
    var intimeOrder = new Padding(
      padding: new EdgeInsets.only(right:0.5,left:0.5),
      child: new SizedBox(
        height: 200.0,
        child: chart2,
      ),
    );
    ScreenUtil.instance = ScreenUtil(width: 375, height: 672, allowFontScaling: true)..init(context);
    SelfAdapt _adpt = SelfAdapt.init(context); // 使用util工具
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
      drawer: Drawer(
        child: drawerPage(_projectName,_userName, _adpt, _postName, _phoneNum, _departmentName, context),
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
                              gradientLine(true),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(4, 38, 83, 0.35),
                                ),
                                height: setHeight(72),
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
                                                  child: GestureDetector(
                                                    child: Center(
                                                      child: Image.asset('assets/images/people.png'),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: GestureDetector(
                                                      child: Center(
                                                        child: Text('当前在岗人数', style: TextStyle(color: Color(0xFFffffff), fontSize: setFontSize(14))),
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
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(this._currentPeopleNum.toString(), style: TextStyle(color: Color.fromRGBO(106, 167, 255, 1), fontSize: setFontSize(60))),
                                        ),
                                        onTap: () async {
                                          await getOnlineOutline();
                                          showModalBottomSheet(
                                            elevation: 80.0,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return PeopleBottomSheet(
                                                online: Online,
                                                outline: Outline,
                                                data: peopleData,
                                              );
                                            }
                                          );
                                        },
                                      )
                                    )
                                  ],
                                ),
                              ),
                              gradientLine(false),
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
                                                                padding: new EdgeInsets.only(left: 4.0,top: 4.0),
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
                                                              Container(
                                                                child: Text('已完成率:',style: TextStyle(color: Color(0XFFffffff),fontSize: setFontSize(14)),),
                                                              ),
                                                              new Padding(
                                                                padding: new EdgeInsets.only(left: 4.0,top: 4.0),
                                                                child: new Text(this._orderHas,style: TextStyle(color: Color(0XFF00FF00),fontSize: setFontSize(14))),
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
                                                  child: Image.asset('assets/images/bao.png',width: setWidth(54),height: setHeight(54)),
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
                                                                padding: new EdgeInsets.only(left: 4.0,top: 4.0),
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
                                                                padding: new EdgeInsets.only(left: 4.0,top: 4.0),
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
                              SizedBox(
                                height: 10.0,
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
                                    orderFrom,
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
                                          child: Center(
                                            child: Text(this._currentOrderAll.toString(),style: TextStyle(color: Color(0xFF0099FF)))
                                          ),
                                        )
                                      ],
                                    ),
                                    intimeOrder,
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

// 渐变色线条
Widget gradientLine(isTop) {
  return Container(
    margin: isTop ? EdgeInsets.only(top: 10.0) : EdgeInsets.only(top: 0.0),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Colors.transparent, Color.fromARGB(255, 59, 137, 249), Colors.transparent]),
    ),
    height: setHeight(1),
  );
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