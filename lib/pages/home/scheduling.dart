import 'package:flutter/material.dart';
import '../../utils/util.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/pageHttpInterface/shiftDuty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pageHttpInterface/Login.dart';

// 组件
import './view/schedulingDatePrick.dart';
import '../Login.dart';
import 'view/drawerPage.dart';

class Scheduing extends StatefulWidget {
  Scheduing({Key key}) : super(key: key);
  _ScheduingState createState() => _ScheduingState();
}
class _ScheduingState extends State<Scheduing> {
  String dateString; //日期字符串
  List pageData = []; //页面数据
  // 用户信息
  String _token = '';
  String _userName = '';
  String _postName = '';
  String _departmentName = '';
  String _phoneNum = '';
  String _projectName = '';
  @override initState(){
    super.initState();
    setState(() {
      dateString = getCurrentTime(timeParams: 3);
    });
    _initUserInfo();
    this.getPageData();
  }
  //获取页面数据
  void getPageData(){
    var params = {
      'date': dateString, //用户id
    };
    getAllWorks(params).then((data){
      var list = [];
      if (data != null && data is List) {
        data.forEach((item){
          item['worklist'].forEach((itemx){
            if (itemx['workshiftId'] != 0) {
              list.add(itemx);
            }
          });
        });
        setState(() {
          pageData = list;
        });
      }
    });
  }
  // 获取用户信息
  _initUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? '');
    });
    if (_token != '') {
      setState(() {
        _userName = (prefs.getString('userName') ?? '');
        _postName = (prefs.getString('postName') ?? '');
        _departmentName = (prefs.getString('departmentName') ?? '');
        _phoneNum = (prefs.getString('phoneNum') ?? '');
        _projectName = (prefs.getString('projectName') ?? '');
      });
    }
  }
  // 退出登录
  void signOut() async{
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
      builder: (context) => Login()
    ));
  }
  // 日期切换
  void prickDateChange(value){
    setState(() {
      dateString = value;
    });
    this.getPageData();
  }
  @override
  Widget build(BuildContext context) {
    var _adapt  = SelfAdapt.init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('排班表', style: TextStyle(fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.transparent,

      ),
      drawer: new Drawer(
        child: drawerPage(_projectName,_userName, _adapt, _postName, _phoneNum, _departmentName, context),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SchedulingDatePrick(change: this.prickDateChange),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left:_adapt.setWidth(20)),
                child: ListView.builder(
                  itemCount: pageData.length,
                  itemBuilder: (context, index) {
                    var item = pageData[index];
                    return ListItem(data: item);
                  },
                )
              )
            )
          ],
        )
      )
    );
  }
}
// 列表 List
class ListItem extends StatelessWidget {
  ListItem({Key key, this.data}) : super(key: key);
  var data;
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    String userPhone = data['userPhone'];
    String workshiftName = data['workshiftName'] + '班';
    String timeSlot = '';
    if (data['workshiftSartTime'] != null && data['workshiftEndTime'] != null) {
      timeSlot = data['workshiftSartTime'] +' - '+ data['workshiftEndTime'];
    }
    return Container(
      height: _adapt.setHeight(65),
      child: Container(
        height: _adapt.setHeight(65),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right:_adapt.setWidth(20)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text( data['userName'], style: TextStyle(color: white_name_color, fontSize: _adapt.setFontSize(18))),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            color: Colors.lightBlue,
                            onPressed: (){
                              if (userPhone != null) {
                                launch("tel:$userPhone");
                              }else{
                                showTotast('暂无电话号码信息！');
                              }
                            },
                            icon: Image(image: new AssetImage('assets/images/phone.png'), width: _adapt.setWidth(16),height: _adapt.setWidth(16)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text( workshiftName, style: TextStyle(color: Color.fromRGBO(181, 215, 255, 1), fontSize: _adapt.setFontSize(18))),
                        ),
                        Container(
                          width: _adapt.setWidth(100),
                          margin: EdgeInsets.only(top: _adapt.setHeight(5)),
                          child: Text( timeSlot, style:TextStyle(color: Color.fromRGBO(153, 153, 153, 1), fontSize: _adapt.setFontSize(15))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Color.fromRGBO(28, 59, 101, 1),
              height: _adapt.setHeight(1),
            )
          ],
        ),
      ),
    );
  }
}