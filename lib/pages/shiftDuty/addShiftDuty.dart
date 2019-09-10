// 排班申请页面
import 'package:flutter/material.dart';
import '../../utils/util.dart';
import '../../services/pageHttpInterface/MyTask.dart';
import '../../services/pageHttpInterface/shiftDuty.dart';

// 组件
import '../../components/ListBarComponents.dart';
import '../../components/SplitLine.dart';
import '../../components/NoteEntry.dart';
import '../../components/ButtonsComponents.dart';
import '../../components/ButtomPopuSheet.dart';



class AddShiftDuty extends StatefulWidget {
  AddShiftDuty({Key key}) : super(key: key);

  _AddShiftDutyState createState() => _AddShiftDutyState();
}

class _AddShiftDutyState extends State<AddShiftDuty> {
  String userName = ''; //用户名
  int userId; //用户id
  String personName; //人员名字
  int personId; //人员id
  String description; //申请原因
  List userList = []; //人员列表
  List proposerDutyList = []; //申请人班次
  List shiftDutyList = []; // 换班班次

  String proposerWorkName; //申请人班次名字
  int proposerWorkID; //申请人班次id

  String shiftDutyWorkName; //换班人班次名字
  int shiftDutyWorkID; //换班人班次id



  @override
  void initState(){
    super.initState();
    initData();
  }
  // 初始化数据
  initData(){
    getLocalStorage('userName').then((value){
      userName = value;
    });
    getLocalStorage('userId').then((value){
      userId = int.parse(value);
      getWorkList(userId);
    });
    // 获取人员列表
    getUserList({'flag': 1}).then((data){
      if(data is List){
        setState(() {
          userList = data;
        });
      }
    });
  }
  // 获取班次
  void getWorkList(id) {
    getOneUserWorkList({'userId': id}).then((data){
      if (data is List) {
        if (userId == id) { //申请人班次
          setState(() {
            proposerDutyList = data;
          });
        }else{ //换班班次
          setState(() {
            shiftDutyList = data;
          });
        }
      }
    });
  }
  // 提交排班申请
  void submit(){
    if (proposerWorkID == null) {
      showTotast('请选择申请人班次！');
      return;
    }
    if (shiftDutyWorkID == null) {
      showTotast('请选择换班班次！');
      return;
    }
    if (description == null) {
      showTotast('请填写申请原因！');
      return;
    }
    Map params = {
      'srcId': proposerWorkID, //申请换班人班次id
      'dstId': shiftDutyWorkID, //换班人班次id
      'description':  description // 申请原因
    };
    // 提交换班申请
    getShiftDuty(params).then((value){
      if (value != null && value is bool) {
        Navigator.pop(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('排班申请', style: TextStyle(fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.transparent
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: _adapt.setHeight(91),
                        width: double.infinity,
                        color: module_background_color,
                        padding: EdgeInsets.only(left: _adapt.setWidth(15.0)),
                        margin: EdgeInsets.only(top: _adapt.setHeight(8.0)),
                        child: Column(
                          children: <Widget>[
                              ListBarComponents(name: '申请人', value: userName),
                              SplitLine(),
                              ListBarComponents(name: '申请人班次', value: proposerWorkName, rightClick:(){
                                buttomPopuSheet(context, proposerDutyList, 2, (item, name){
                                  setState(() {
                                    proposerWorkName = name;
                                    proposerWorkID = item['ID'];
                                  });
                                });
                              } ),
                          ],
                        ),
                      ),
                      Container(
                        height: _adapt.setHeight(91),
                        width: double.infinity,
                        color: module_background_color,
                        padding: EdgeInsets.only(left: _adapt.setWidth(15.0)),
                        margin: EdgeInsets.only(top: _adapt.setHeight(8.0)),
                        child: Column(
                          children: <Widget>[
                              ListBarComponents(name: '换班人员', value: personName, rightClick:(){
                                buttomPopuSheet(context, userList, 1, (item){
                                  if (personId != item['userId']) {
                                      setState(() {
                                        personName = item['userName'];
                                        personId = item['userId'];
                                        shiftDutyWorkName = null;
                                        shiftDutyWorkID = null;
                                      });
                                      this.getWorkList(item['userId']);
                                  }
                                });
                              }),
                              SplitLine(),
                              ListBarComponents(name: '换班班次', value: shiftDutyWorkName, rightClick:(){
                                if (personId == null) {
                                  showTotast('请先选择换班人员！');
                                }else{
                                  buttomPopuSheet(context, shiftDutyList, 2, (item, name){
                                    setState(() {
                                      shiftDutyWorkName = name;
                                      shiftDutyWorkID = item['ID'];
                                    });
                                  });
                                }
                              }),
                          ],
                        ),
                      ),
                      NoteEntry(title:'申请原因', change: (value){
                          setState(() {
                            description = value;
                          });
                      })
                    ],
                  ),
                ),
              ),
              Container(
                child: ButtonsComponents(leftName: '提交', cbackLeft: this.submit, rightShow: false,),
              )
            ],
          )
        ),
    );
  }
}