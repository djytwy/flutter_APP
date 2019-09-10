import 'package:flutter/material.dart';
import '../../../utils/util.dart';
import '../../../services/pageHttpInterface/shiftDuty.dart';
import '../../../utils/eventBus.dart';

class ListItem extends StatelessWidget {
  ListItem({Key key, this.data, this.clickCback, this.isShowImg = false}) : super(key: key);
  var data;
  Function clickCback;
  final bool isShowImg;

  // 返回图片
  BoxDecoration cbackImage(){
    if (!isShowImg) {
      return BoxDecoration();
    }
    if (data['prcessStat'] == 2) {
        return BoxDecoration(
            image: new DecorationImage(
              alignment: Alignment.centerRight,
              image: new AssetImage('assets/images/pass.png'),  
            ),
          );
    }else if (data['prcessStat'] == 4) {
        return BoxDecoration(
              image: new DecorationImage(
                alignment: Alignment.centerRight,
                image: new AssetImage('assets/images/noPass.png'),  
              ),
            );
    }else{
      return BoxDecoration();
    }
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    var srcWorkshiftName = data['srcWorkshiftDate'] +' '+ data['srcStartTime']+' - '+ data['srcEndTime']+' '+data['srcWorkshiftName']+'班';
    var dstWorkshiftName = data['dstWorkshiftDate'] +' '+ data['dstStartTime']+' - '+ data['dstEndTime']+' '+data['dstWorkshiftName']+'班';
    return Container(
      child: GestureDetector(
        onTap: (){
          if (clickCback != null) {
            // 只有未读消息点击才去修改状态
            if (data['isRead'] != null && data['isRead']) {
              getChangeWorksStatus({
                'operFlag': 3,
                'msgId': data['msg_id']
              });
              // 刷新 换班信息
              bus.emit("refreshTask");
            }
            clickCback(data['Id']);
          }
        },
        child: Container(
              padding: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(15), _adapt.setWidth(15), _adapt.setHeight(15)),
              margin: EdgeInsets.fromLTRB(_adapt.setWidth(15), _adapt.setHeight(5), _adapt.setWidth(15), _adapt.setHeight(5)),
              decoration: BoxDecoration(
                color: module_background_color,
                borderRadius: BorderRadius.all(new Radius.circular(5)),
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
                        Expanded(
                          child: Text( data['srcUserName'], style: TextStyle(color:  white_color),),
                        ),
                        Offstage(
                          offstage: data['isRead'] != null && data['isRead'] == true ? false : true,
                          child: Container(
                            width: _adapt.setWidth(8),
                            height: _adapt.setWidth(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: cbackImage(),
                    child: Column(
                      children: <Widget>[
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
                                child: Text('换班人员：',  textAlign: TextAlign.right, style: TextStyle(color: white_name_color)),
                              ),
                              Expanded(
                                child: Text( data['dstUserName'], style: TextStyle(color:  white_color),),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(bottom: _adapt.setHeight(13)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: _adapt.setWidth(75),
                          child: Text('班次：', textAlign: TextAlign.right, style: TextStyle(color: white_name_color)),
                        ),
                        Expanded(
                          child: Text(dstWorkshiftName, style: TextStyle(color:  white_color)),
                        )
                      ],
                    ),
                  )
                ],
            ),
          )
        ),
    );
  }
}