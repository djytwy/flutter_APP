/**
 * 抄送人的bar的多选组件
 * author: djytwy on 2019-11-18 11:11
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../reportFix/copierDepartment.dart';    // 抄送人
import '../../reportFix/view/copierList.dart';     // 抄送人
import '../../../services/pageHttpInterface/Copier.dart';  // 抄送人HTTP服务

class CopierItem extends StatefulWidget {
  CopierItem({
    Key key,
    this.clickCB   // 回调函数
  }):super();
  final clickCB;

  @override
  _CopierItemState createState() => _CopierItemState();
}

class _CopierItemState extends State<CopierItem> {
  List defaulttCopierList = []; //默认抄送人列表
  List copierList = []; //抄送人列表-- 包含部门
  List copierUsers = []; //抄送人列表-- 不包含部门
  List copierIds = []; //抄送人id
  List copierSelects = []; //抄送人的列表-用于显示名字

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 获取抄送人列表
    getCopierList().then((data){
      if (data != null) {
        List users = [];
        // 把所以抄送人从部门里面取出来
        data.forEach((item){
          if (item['childs'] != null && item['childs'].length > 0) {
            users.addAll(item['childs']);
          }
        });
        setState(() {
          copierList = data;
          copierUsers = users;
        });
      }
    });
    // 获取默认抄送人
    getDefaulttCopierList().then((data) {
      if (data != null && data is List) {
        var list = [];
        data.forEach((item) {
          list.add({
            'isNoDel': true,
            'userName': item['userName'],
            'userID': item['userId']
          });
        });
        setState(() {
          defaulttCopierList = list;
          copierSelects = list;
        });
      }
    });
  }

  // 删除抄送人
  void delCopier(item){
    List list = [];
    List ids = [];
    List copierLists = [];
    // 清空选中的id, 和 列表数据中 selectList
    copierSelects.forEach((itemx){
      if (item['userID'] != itemx['userID']) list.add(itemx);
    });
    copierIds.forEach((itemx){
      if (item['userID'] != itemx) ids.add(itemx);
    });
    // 抄送列表，包含id
    copierList.forEach((itemx){
      if(itemx['selectList'] != null && itemx['selectList'].contains(item['userID'])){
        itemx['selectList'].remove(item['userID']);
      }
      copierLists.add(itemx);
    });
    setState(() {
      copierIds = ids;
      copierSelects = list;
      copierList = copierLists;
    });
    widget.clickCB(list);
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = ScreenUtil.getInstance().setSp(15);
    return Container(
      color: Color.fromARGB(100, 12, 33, 53),
      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: ScreenUtil.getInstance().setWidth(30)
              ),
              child: Text('抄送人',textAlign: TextAlign.left,style: TextStyle(color: Colors.white70),)
            ),
          ),
          CopierList(data: copierSelects, delCopier: delCopier, pageCback: () async {
            final val = await Navigator.push(context, MaterialPageRoute(
              builder: (context) => CopierDepartment(data: copierList)
            ));
            if (val != null) {
              List list = [];
              // 根据id 获取名字
              val['selects'].forEach((item){
                copierUsers.forEach((itemx){
                  if (item == itemx['userID']) {
                    list.add(itemx);
                  }
                });
              });
              // 触发回调函数
              widget.clickCB(list);
              // 根据返回的数据赋值
              setState(() {
                copierList = val['data'];
                copierIds = val['selects'];
                copierSelects = [...defaulttCopierList, ...list];
              });
            }
          })
        ],
      ),
    );
  }
}

