// 待审批页面
import 'package:flutter/material.dart';
import '../../utils/util.dart';
import '../../services/pageHttpInterface/shiftDuty.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
//页面
import './approvalPendingDetail.dart';
// 组件
import '../workOrder/view/PrivateDatePrick.dart';
import './view/listItem.dart';

class ApprovalPendingList extends StatefulWidget {
  ApprovalPendingList({Key key, this.type, this.title}) : super(key: key);
  final String type; //类型 -- 1管理员已审批 2 管理员未审批 3普通员工 我的处理 4 普通员工已审批 5普通员审批中
  final String title;
  _ApprovalPendingListState createState() => _ApprovalPendingListState();
}

class _ApprovalPendingListState extends State<ApprovalPendingList> {
  String userName = ''; //用户名
  int userId; //用户id
  String dateString; //日期字符串
  var pageData = []; //页面数据
  int total = 0; //总个数
  int pageNum = 1; //页码
  int pageSize = 10; //每页个数
  List unreadList = []; //未读列表
  bool unreadStatus = true; // 请求未读数据状态标记
  @override
  void initState(){
    super.initState();
    initData();
  }
  // 初始化数据
  initData(){
    getLocalStorage('userId').then((value){
      setState(() {
        userId = int.parse(value);
         dateString = getCurrentDay();
      });
      this.getPageData();
    });
  }
  // 获取页面数据
  void getPageData(){
    var params = {
      'userId': userId,
      'type': widget.type,
    };
    if (dateString != null) {
      params['date'] = dateString;
    }
    if (pageNum > 1 && total < pageNum * pageSize) {
      pageNum -=1;
      showTotast('没有更多数据', 'bottom');
      return;
    }
    getShiftDutyList(params).then((data){
      if (data != null && data is Map) {
        List list = [];
        if (pageNum == 1) {
          list = data['list'];
        }else if(pageNum > 1){
          list = [...this.pageData, ...data['list']];
        }
        setState(() {
          pageData = list;
          total = data['total'];
        });
        //处理未读状态标记
        if (data['total'] > 0  && unreadStatus) {
          getUnreadList();
        }else{
          formatUnreadList();
        }
      }
    });
  }
  // 获取未读数据列表
  void getUnreadList(){
    var params = {
        'userId': userId,
        'submodelId': 2,
        'msgType': 1,
        'msgIsread': 0,
        'msgStatus': 0 // 200-我的处理;201-待审批;202-审批中;203-管理员已审批；204-普通员工已同意]
    };
    if (widget.type == '3') {
      params['msgStatus'] = 200;
    }else if (widget.type == '2') {
      params['msgStatus'] = 201;
    }
    // 获取未读列表
    getAllWorksStatus(params).then((data){
      if (data != null && data is List) {
          setState(() {
            unreadStatus = false;
            unreadList = data;
          });
          formatUnreadList();
      }
    });
  }
  // 转换未读数据
  void formatUnreadList(){
   if (pageData.length == 0 || unreadList.length == 0) {
      return;
    }
    List list = [];
    pageData.forEach((item){
        item['isRead'] = false;
        item['msg_id'] = 0;
        unreadList.forEach((itemx){
          if (item['Id'] == int.parse(itemx['msg_ext_id'])) {
            item['isRead'] = true;
            item['msg_id'] = itemx['msg_id'];
          }
        });
        list.add(item);
    });
    setState(() {
      pageData = list;
    });
  }
  // 日期选择 组件回调
  void datePrickChange(value){
    setState(() {
      dateString = value;
       pageNum = 1;
    });
    this.getPageData();
  }
  // 列表点击
  void listClick(id) async{
    pageData.forEach((item){
      if (item['Id'] == id) {
        item['isRead'] = false;
      }
    });
    var flg = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ApprovalPendingDetail(id: id, type: widget.type)
    ));
    if (flg != null) {
      setState(() {
        pageNum = 1;
      });
      this.getPageData();
    }
  }
  // 分页
  Future _onload() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        pageNum += 1;
      });
      this.getPageData();
    });
  }
  // 刷新
  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        pageNum = 1;
      });
      this.getPageData();
    });
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    String countName =  '共' + pageData.length.toString() + '单';
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
            title: Text( widget.title, style: TextStyle(fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              // 时间组件占位
              PrivateDatePrick(change: datePrickChange)
            ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(8), _adapt.setWidth(15), 0),
                child: Text( countName, style: TextStyle(color: Color.fromRGBO(165, 165, 165, 1), fontSize: _adapt.setFontSize(12))),
              ),
              Expanded(
                child: EasyRefresh(
                  onLoad: _onload,
                  onRefresh: _refresh,
                  child:  ListView.builder(
                    itemCount: pageData.length,
                    itemBuilder: (context, index) {
                      var item = pageData[index];
                      return ListItem(data: item, clickCback: this.listClick,);
                    },
                  )
                ),
              )
            ],
          )
        ),
    );
  }
}