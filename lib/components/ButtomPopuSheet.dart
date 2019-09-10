//底部弹出框
import 'package:flutter/material.dart';
import '../utils/util.dart';
//type ： 1: 换班人员 , 2: 班次
void buttomPopuSheet(context, data, type, cback) async{
  var str = await getLocalStorage('userId');
  int userId = int.parse(str);
  var _adapt = SelfAdapt.init(context);
  if (data.length  > 0) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: _adapt.setHeight(46),
                  padding: EdgeInsets.only(left: _adapt.setWidth(0), right: _adapt.setWidth(40)),
                  color: Color.fromRGBO(0,20,37,1),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: _adapt.setWidth(40),
                        child: FlatButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text( type == 1 ? '请选择人员' : type == 2 ? '请选择班次' : '', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _adapt.setFontSize(16))),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles:  type == 1 ?  shiftChangersFillData(context, data, userId, cback) : type == 2 ? workListFillData(context, data, cback) : ''
                    ).toList()
                  ),
                )
              ],
            ),
        );
      }
    );
  }else{
    showTotast('未获取到数据！');
  }
}
// 遍历 数据，填充  -- 角色列表
List<Widget> roleFillData(context, data, cback){
    List<Widget> list = [];//先建一个数组用于存放循环生成的widget
    for(var item in data){
        String str = item['flag'] == 1 ? '（无人在岗）' : '';
        Color color = item['flag'] == 0 ? Color.fromRGBO(173, 216, 255, 1) : Color.fromRGBO(151, 151, 151, 1);
        list.add(
          Container(
            child: Container(
            // height: setHeight(44),
            // margin: EdgeInsets.only(top: setHeight(7), bottom: setHeight(8), left: setWidth(15), right: setWidth(15)),
            decoration: new BoxDecoration(
              // color: Color.fromRGBO(0, 20, 37, 1),
              // borderRadius: new BorderRadius.all(new Radius.circular(5)),
            ),
            child: ListTile(
                selected: true,
                enabled: item['flag'] == 0 ? true : false,
                title: Text( item['roleName'] + str, textAlign: TextAlign.center, style: TextStyle(color: color),),
                onTap: () async {
                  cback(roleId: item['roleId'], optionType: 1 ); //指派方法
                  Navigator.pop(context);
                }
              )
            )
          ),
        );
    }
    return list;
}

  // 换班人员
List<Widget> shiftChangersFillData(context, data, userId, cback){
    List<Widget> list = [];//先建一个数组用于存放循环生成的widget
    for(var item in data){
        if (item['userId'] != userId) {
            list.add(
              Container(
                child: Container(
                decoration: new BoxDecoration(
                ),
                child: ListTile(
                    selected: true,
                    title: Text(item['userName'], textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(173, 216, 255, 1)),),
                    onTap: () async {
                      cback(item); //同意退单
                      Navigator.pop(context);
                    }
                  )
                )
              ),
            );
        }
    }
    return list;
}
// 换班班次
List<Widget> workListFillData(context, data, cback){
    List<Widget> list = [];//先建一个数组用于存放循环生成的widget
    for(var item in data){
      String workshiftDate = item['workshiftDate'];
      String startTime = item['startTime'];
      String endTime = item['endTime'];
      String workshiftName = item['workshiftName'];
      String name = '$workshiftDate $startTime - $endTime $workshiftName班';
        list.add(
          Container(
            child: Container(
            decoration: new BoxDecoration(
            ),
            child: ListTile(
                selected: true,
                title: Text(name, textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(173, 216, 255, 1)),),
                onTap: () async {
                  cback(item, name); //同意退单
                  Navigator.pop(context);
                }
              )
            )
          ),
        );
    }
    return list;
}