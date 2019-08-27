import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_echart/flutter_echart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/Login.dart';
import '../../services/pageHttpInterface/scheduling.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
class Schdeuling extends StatefulWidget {
  Schdeuling({Key key}) : super(key: key);

  _SchdeulingState createState() => _SchdeulingState();
}
const String MIN_DATETIME = '2010-05-12';
const String MAX_DATETIME = '2021-11-25';
class _SchdeulingState extends State<Schdeuling> {
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
  List _orderNum = [];
  List _orderName = [];
  // 即时工单的数据
  int _currentOrderAll = 0;
  List _currentOrderNum = [];
  List _currentOrderName = [];
  @override
  void initState() {
    super.initState();
    _initUserInfo();
  }
  _initUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? '');
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
        for (var item in val['info']) {
          setState(() {
            _orderNum.add(item['num']);
          });
        }
        for (var item in val['info']) {
          setState(() {
            _orderName.add(item['label']);
          });
        }
      });
    });
  }
  // 获取即时工单的数据
  void getCurrentOrderData(token,userId,date) {
    getCurrentOrder(token,userId,date).then((val) {
      print('9999999999999999999999999999');
      print(val);
      setState(() {
        _currentOrderAll = val['taskCount'];
        for (var item in val['info']) {
          setState(() {
            _currentOrderNum.add(item['num']);
          });
        }
        for (var item in val['info']) {
          setState(() {
            _currentOrderName.add(item['label']);
          });
        }
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
        print('00000000000000');
        print(_dateTime);
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
  Widget build(BuildContext context) {
    // return Center(
    //     child: Text('排班页面', style: TextStyle(color: Colors.white)),
    //   );
    var sourceOption = {
      'backgroundColor': '#000000',
      'color': ['#4A90E2'],
      // 'tooltip' : {
      //   'trigger': 'axis',
      // },
      'grid': {
        'left': '3%',
        'right': '4%',
        'bottom': '3%',
        'containLabel': true
      },
      'xAxis' : [
        { 
          'type' : 'category',
          'data' : this._orderName,
          'axisTick': {
              'show': false,
          },
          'axisLine': {
            'lineStyle': {
              'color': '#1C3B65'
            }
          },
          'axisLabel': {
            'textStyle': {
              'color': '#ffffff'
            }
          }
        }
      ],
      'yAxis' : [
          {
            'type' : 'value',
            'axisTick': {
              'show': false,
            },
            'splitLine': {
              'show': false,
            },
            'axisLine': {
              'lineStyle': {
                'width': 0
              }
            },
            'axisLabel': {
              'textStyle': {
                'color': '#ffffff'
              }
            }
          }
      ],
      'series' : [
        {
          'name':'直接访问',
          'type':'bar',
          'barWidth': '22',
          'data':this._orderNum,
          'itemStyle': {
            'normal': {
              'label': {
                'show': true,
                'position': 'top',
                'textStyle': {
                  'color': '#ffffff'
                }
              }
            }
          }
        }
      ]
    };
    var immediateOption = {
      'backgroundColor': '#000000',
      'color': ['#4A90E2'],
      // 'tooltip' : {
      //   'trigger': 'axis',
      // },
      'grid': {
        'left': '3%',
        'right': '4%',
        'bottom': '3%',
        'containLabel': true
      },
      'xAxis' : [
        { 
          'type' : 'category',
          'data' : this._currentOrderName,
          'axisTick': {
              'show': false,
          },
          'axisLine': {
            'lineStyle': {
              'color': '#1C3B65',
              'fontSize': '12'
            }
          },
          'axisLabel': {
            'interval': 0,  
            'textStyle': {
              'color': '#ffffff'
            }
          }
        }
      ],
      'yAxis' : [
          {
            'type' : 'value',
            'axisTick': {
              'show': false,
            },
            'splitLine': {
              'show': false,
            },
            'axisLine': {
              'lineStyle': {
                'width': 0
              }
            },
            'axisLabel': {
              'textStyle': {
                'color': '#ffffff'
              }
            }
          }
      ],
      'series' : [
        {
          'name':'直接访问',
          'type':'bar',
          'barWidth': '22',
          'data':this._currentOrderNum,
          'itemStyle': {
            'normal': {
              'label': {
                'show': true,
                'position': 'top',
                'textStyle': {
                  'color': '#ffffff'
                }
              }
            }
          }
        }
      ]
    };
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
              Expanded(
                child: Center(
                  child: Text('首页',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(16))),
                ),
              ),
              Expanded(
                flex: 0,
                child: new DropdownButton(
                  items: getListData(),
                  hint:new Text('选择时间',style: TextStyle(color: Color(0xFFff0000)),),//当没有默认值的时候可以设置的提示
                  value: value,//下拉菜单选择完之后显示给用户的值
                  onChanged: (T){//下拉菜单item点击之后的回调
                    print(T);
                    if (T == '1') {
                      setState(() {
                        _format = 'yyyy';
                      });
                      this._showDatePicker();
                    } else if (T == '2') {
                      setState(() {
                        _format = 'yyyy-MMMM';
                      });
                      this._showDatePicker();
                    } else if (T == '3') {
                      setState(() {
                        _format = 'yyyy-MMMM-dd';
                      });
                      print('88888888');
                      this._showDatePicker();
                    }
                    setState(() {
                      value=T;
                    });
                  },
                  elevation: 24,//设置阴影的高度
                  style: new TextStyle(//设置文本框里面文字的样式
                    color: Colors.red
                  ),
                   // isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                  iconSize: 20.0,//设置三角标icon的大小
                ),
                // child: IconButton(
                //   icon: Icon(Icons.people),
                //   onPressed: this._showDatePicker,
                // ),
              )
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
            ListTile(title: Text(this._departmentName,style: TextStyle(color: Color(0xFFffffff))),
              enabled: false,
              leading: new CircleAvatar(child: new Text('部门',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(14)),),),
              onTap: () {
                Navigator.pop(context);
              },),
            ListTile(title: Text(this._phoneNum,style: TextStyle(color: Color(0xFFffffff))),
              enabled: false,
              leading: new CircleAvatar(child: new Text('电话',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(14)),),),
              onTap: () {
                Navigator.pop(context);
              },),
            ListTile(title: Text(this._postName,style: TextStyle(color: Color(0xFFffffff))),
              enabled: false,
              leading: new CircleAvatar(
                child: new Text('职位',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(14)),),),
              onTap: () {
                Navigator.pop(context);
              },),
            ListTile(title: Text('修改密码',style: TextStyle(color: Color(0xFFffffff))),
            trailing: Icon(Icons.keyboard_arrow_right,color: Color(0xFFfffffff),),
            leading: new CircleAvatar(
              child: new Text('修改',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(14)),),),
            onTap: () {
              Navigator.pop(context);
            },),
            ListTile(title: Text('退出登录',style: TextStyle(color: Color(0xFFffffff))),
            leading: new CircleAvatar(
            child: new Text('退出',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(14)),),),
            onTap: signOut),
          ],
          ),
        ),
      ),
      body: Container(
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
                                                  child: Icon(Icons.people,color: Color.fromRGBO(106, 167, 255, 1),)
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
                                            child: Icon(Icons.people,color: Color.fromRGBO(106, 167, 255, 1),size: 40,),
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
                                                          child: new Text(this._orderHas,style: TextStyle(color: Color(0XFFff5500),fontSize: setFontSize(14)),),
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
                                            child: Icon(Icons.people,color: Color.fromRGBO(106, 167, 255, 1),size: 40,),
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
                                                          child: new Text(this._siteHas,style: TextStyle(color: Color(0XFFff5500),fontSize: setFontSize(14)),),
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
                          height: setHeight(200),
                          width: setWidth(375),
                          color: Color.fromRGBO(4, 38, 83, 0.35),
                          margin: EdgeInsets.only(top: setHeight(10)),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width: setWidth(140),
                                  margin: EdgeInsets.only(top: setHeight(10)),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('工单来源  |  总数:',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(14)),),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Text(this._orderSourceAll.toString(),style: TextStyle(color: Color(0xFF0075FF),fontSize: setFontSize(14))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: setWidth(375.0),
                                  height: setHeight(140.0),
                                  // color: Color(0xFFff0000),
                                  decoration: new BoxDecoration(
                                     image: DecorationImage(
                                      image: AssetImage("assets/images/background.png"),
                                      fit: BoxFit.cover
                                    ),
                                    color: Color.fromRGBO(4, 38, 83, 0.35)
                                  ),
                                  margin: EdgeInsets.only(top: setHeight(10)),
                                  child: EchartView(
                                    height: setHeight(140.0),
                                    data: sourceOption,                   
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: setHeight(200),
                          width: setWidth(375),
                          color: Color.fromRGBO(4, 38, 83, 0.35),
                          margin: EdgeInsets.only(top: setHeight(10)),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width: setWidth(140),
                                  margin: EdgeInsets.only(top: setHeight(10)),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('即时工单  |  总数:',style: TextStyle(color: Color(0xFFffffff),fontSize: setFontSize(14)),),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Text(this._currentOrderAll.toString(),style: TextStyle(color: Color(0xFF0075FF),fontSize: setFontSize(14))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: setWidth(375.0),
                                  height: setHeight(140.0),
                                  decoration: new BoxDecoration(
                                    border: new Border.all(color: Color.fromRGBO(4, 38, 83, 0.35), width: 0.5), 
                                    color: Color.fromRGBO(4, 38, 83, 0.35),
                                  ),
                                  margin: EdgeInsets.only(top: setHeight(10)),
                                  child: EchartView(
                                    height: setHeight(140.0),
                                    data: immediateOption,                     
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
        ), 
      ),
      )
    );
  }
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