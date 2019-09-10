import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/util.dart';


// data['prcessStat'] ----  换班申请状态 0 新建 1 换班人同意 2管理员同意 3换班人拒绝 4 管理员拒绝
class ListItemDetail extends StatelessWidget {
  ListItemDetail({Key key, this.data, this.type, this.btnClickCback}) : super(key: key);
  var data;//数据
  Function btnClickCback;
  String type;

  // 返回图片
  BoxDecoration cbackImage(){
    // 当类型为 管理员已审批 和 普通员工已审批 时，显示图片
    if (type != null && type == '1' || type == '4' || type == '3') {
      if (data != null && data['prcessStat'] == 2) { //管理员通过
        return BoxDecoration(
            image: new DecorationImage(
              alignment: Alignment.centerRight,
              image: new AssetImage('assets/images/pass.png'),  
            ),
          );
      }else if ( data != null && data['prcessStat'] == 4) {// 管理员拒绝
        return BoxDecoration(
              image: new DecorationImage(
                alignment: Alignment.centerRight,
                image: new AssetImage('assets/images/noPass.png'),  
              ),
            );
      }else{
        return BoxDecoration();
      }
    }else{
      return BoxDecoration();
    }
  }
  // 判断是否展示操作按钮
  bool isShowBtn(){
    if (type == '2') { //管理员
      return false;
    }else if ( type == '3' && data != null && data['prcessStat'] == 0) { //普通员工我的处理
      return false;
    }else{
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    var srcWorkshiftName = '';
    var dstWorkshiftName = '';
    var srcUserName = '';
    var dstUserName = '';
    var addtime = '';
    var description = '';
    var dstUserPhone = '';
    var srcUserPhone = '';
    var approverName = '';
    var approverPhone = '';
    var prcessStat = -1;
    if (data != null) {
      srcWorkshiftName = data['srcWorkshiftDate'] +' '+ data['srcStartTime']+' - '+ data['srcEndTime']+' '+data['srcWorkshiftName']+'班';
      dstWorkshiftName = data['dstWorkshiftDate'] +' '+ data['dstStartTime']+' - '+ data['dstEndTime']+' '+data['dstWorkshiftName']+'班';
      srcUserName = data['srcUserName'];
      dstUserName = data['dstUserName'];
      addtime = data['addtime'];
      description = data['description'];
      dstUserPhone = data['dstUserPhone'];
      srcUserPhone = data['srcUserPhone'];
      if (data['prcessStat'] != 0) {
        approverName = data['approverName'];
        approverPhone = data['approverPhone'];
      }
      prcessStat = data['prcessStat'];
    }
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(5), _adapt.setWidth(15), _adapt.setHeight(15)),
            margin: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(5), _adapt.setWidth(15), _adapt.setHeight(5)),
            decoration: BoxDecoration(
              color: Color.fromRGBO(4, 38, 83, 0.35),
              borderRadius: BorderRadius.all(new Radius.circular(5))
            ),
            child: Column(
              children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: _adapt.setHeight(13)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: _adapt.setWidth(75),
                          child: Text('申请人：',  textAlign: TextAlign.right, style: TextStyle(color: white_name_color)),
                        ),
                        Text(srcUserName, style: TextStyle(color:  white_color)),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            color: Colors.lightBlue,
                            onPressed: (){
                              if (srcUserPhone != null) {
                                launch("tel:$srcUserPhone");
                              }else{
                                showTotast('暂无电话号码信息！');
                              }
                            },
                            icon: Image(image: new AssetImage('assets/images/phone.png'), width: _adapt.setWidth(16),height: _adapt.setWidth(16))
                          ),
                        ),
                        Expanded(
                          child: Offstage(
                            offstage: prcessStat == 1 && type == '3' || type == '5' ? false : true,
                            child: Container(
                              alignment: Alignment.topRight,
                              // color: Colors.red,
                              child: Text('审批中', style: TextStyle(color: Color.fromRGBO(80, 227, 194, 1), fontSize: _adapt.setFontSize(15)))
                            )
                          )
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: _adapt.setHeight(13)),
                    child: Row(
                      children: <Widget>[
                      Container(
                          width: _adapt.setWidth(75),
                          child: Text('班次：', textAlign: TextAlign.right, style: TextStyle(color: white_name_color)),
                        ),
                        Expanded(
                          child: Text(srcWorkshiftName, style: TextStyle(color:  white_color),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: _adapt.setWidth(24),
                    width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: _adapt.setHeight(3),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(74, 144, 226, 1),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(2),bottomLeft: Radius.circular(2),bottomRight: Radius.zero, topRight: Radius.zero)
                              ),
                            )
                          ),
                          Container(
                            width: _adapt.setWidth(24),
                            height: _adapt.setWidth(24),
                            decoration: BoxDecoration(
                              border: new Border.all(width: 2, color: Color.fromRGBO(74, 144, 226, 1)),
                              borderRadius: BorderRadius.all(new Radius.circular(12))
                            ),
                            child: Icon(Icons.cached, size: 18, color: Color.fromRGBO(181, 215, 255, 1))
                          ),
                          Expanded(
                            child: Container(
                              height: _adapt.setHeight(3),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(74, 144, 226, 1),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(2),bottomRight: Radius.circular(2),bottomLeft: Radius.zero, topLeft: Radius.zero)
                              ),
                            )
                          ),
                        ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: _adapt.setHeight(13)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: _adapt.setWidth(75),
                          child: Text('换班人员：',  textAlign: TextAlign.right, style: TextStyle(color: white_name_color)),
                        ),
                        Text( dstUserName, style: TextStyle(color:  white_color)),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            color: Colors.lightBlue,
                            onPressed: (){
                              if (dstUserPhone != null) {
                                launch("tel:$dstUserPhone");
                              }else{
                                showTotast('暂无电话号码信息！');
                              }
                            },
                            icon: Image(image: new AssetImage('assets/images/phone.png'), width: _adapt.setWidth(16),height: _adapt.setWidth(16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: _adapt.setWidth(75),
                          child: Text('班次：', textAlign: TextAlign.right, style: TextStyle(color: white_name_color)),
                        ),
                        Expanded(
                          child: Text(dstWorkshiftName, style: TextStyle(color:  white_color),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(15), _adapt.setWidth(15), _adapt.setHeight(5)),
              margin: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(5), _adapt.setWidth(15), 0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: module_background_color,
                borderRadius: BorderRadius.all(new Radius.circular(5))
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('换班原因：', style: TextStyle(color: white_name_color)),
                        Expanded(
                          child: Text( description, style: TextStyle(color: white_color)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: cbackImage(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: _adapt.setHeight(10), bottom: _adapt.setHeight(10)),
                          child: Row(
                            children: <Widget>[
                              Text('申请时间：', style: TextStyle(color: white_name_color)),
                              Expanded(
                                child: Text(addtime, style: TextStyle(color: white_color)),
                              )
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: (type == '3' && data != null && data['prcessStat'] == 0 || data != null && data['prcessStat'] == 1) || type == '2'? true : false,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: _adapt.setWidth(71),
                                  child: Text('审批人：',  textAlign: TextAlign.right, style: TextStyle(color: white_name_color)),
                                ),
                                Text( approverName, style: TextStyle(color:  white_color)),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    color: Colors.lightBlue,
                                    onPressed: (){
                                      if (approverPhone != null) {
                                        launch("tel:$approverPhone");
                                      }else{
                                        showTotast('暂无电话号码信息！');
                                      }
                                    },
                                    icon: Image(image: new AssetImage('assets/images/phone.png'), width: _adapt.setWidth(16),height: _adapt.setWidth(16)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: isShowBtn(),
                    child: Container( //操作按钮
                      margin: EdgeInsets.only(top: _adapt.setHeight(5)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: _adapt.setHeight(2),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(28, 59, 101, 1),
                              borderRadius: BorderRadius.all(Radius.circular(1))
                            ),
                          ),
                          Container(
                            height: _adapt.setHeight(30),
                            margin: EdgeInsets.only(top: _adapt.setHeight(5)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: FlatButton(
                                      onPressed: (){
                                        if(data == null){
                                          showTotast('暂未获取到信息！');
                                        }else{
                                          btnClickCback(data['Id'], 1);
                                        }
                                      },
                                      child: Text('拒绝', style:  TextStyle(color: Color.fromRGBO(74, 144, 226, 1)))
                                    ),
                                  )
                                ),
                                Container(
                                  width: _adapt.setWidth(1),
                                  height: _adapt.setHeight(15),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(28, 59, 101, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(1))
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: FlatButton(
                                      onPressed: (){
                                        if(data == null){
                                            showTotast('暂未获取到信息！');
                                        }else{
                                          btnClickCback(data['Id'], 2);
                                        }
                                      },
                                      child: Text('同意', style: TextStyle(color: Color.fromRGBO(129, 226, 231, 1))),
                                    ),
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}