// 待审批详情页面
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../utils/util.dart';
import '../../services/pageHttpInterface/shiftDuty.dart';

// 组件
import './view/listItemDetail.dart';


class  ApprovalPendingDetail extends StatefulWidget {
  ApprovalPendingDetail({Key key, this.id, this.type}) : super(key: key);
  final int id;
  final String type; // 2 --表示管理员端进来的， 3 --- 表示普通员工端进来的
  _ApprovalPendingDetailState createState() => _ApprovalPendingDetailState();
}

class _ApprovalPendingDetailState extends State<ApprovalPendingDetail> {
  String userName = ''; //用户名
  String userPhone = ''; //用户电话
  int userId; //用户id
  var pageData; // 页面数据

  @override
  void initState(){
    super.initState();
    initData();
  }
  // 初始化数据
  initData(){
    getLocalStorage('userId').then((value){
      userId = int.parse(value);
    });
    getLocalStorage('userName').then((value){
      userName = value;
    });
    getLocalStorage('phoneNum').then((value){
      userPhone = value;
    });
    // 获取页面数据
    getShiftDutyDetail({'workChangeId': widget.id}).then((data){
      if (data != null && data is Map) {
          setState(() {
            pageData = data;
          });
      }
    });
  }
  // 处理 换班申请  -- 同意/拒绝
  // id -- 排班列表id, status: 1 拒绝，2 同意
  void handleClick(int id, int status){
    var params = {
        'workChageId': id,
        'userID': userId,
        'userName': userName,
        'userPhone': userPhone,
    };
    // 管理员同意
    if (widget.type == '2' && status == 2) {
      params['optionType'] = 2;
    }else 
    // 管理员拒绝
    if (widget.type == '2' && status == 1) {
      params['optionType'] = 4;
    }else
    // 普通员工同意
    if(widget.type == '3' && status == 2) {
      params['optionType'] = 1;
    }else
    // 普通员工拒绝
    if(widget.type == '3' && status == 1) {
      params['optionType'] = 3;
    }
    getHandleWorkChange(params).then((value){
      if (value != null && value is bool) {
        if (widget.type == '2') {
          Navigator.pop(context, true);
        }else{
          Navigator.pop(context);
        }
      }
    });
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
          appBar: AppBar(
            title: Text('换班申请', style: TextStyle(fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: ListItemDetail(data: pageData, type: widget.type, btnClickCback: this.handleClick)
        ),
    );
  }
}