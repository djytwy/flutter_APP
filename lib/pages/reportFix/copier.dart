// 抄送人
import 'package:flutter/material.dart';
import '../../utils/util.dart';

// 组件
import '../../components/ButtonsComponents.dart';

class Copier extends StatefulWidget {
  Copier({Key key, this.data, this.name}) : super(key: key);
  Map data;
  String name = '';
  _CopierState createState() => _CopierState();
}
class _CopierState extends State<Copier> {
  // 选中列表
  Set selectList = Set();
  List list = [];
  @override void initState() {
    super.initState();
    List data = [];
    Set data1 = Set();
    widget.data['childs'].forEach((item){
      data.add(item);
    });
    if (widget.data['selectList'] != null) {
      widget.data['selectList'].forEach((item){
        data1.add(item);
      });
    }
    setState(() {
      list = data;
      selectList = data1;
    });
  }
  // 点击
  void itemClick(id){
    if (selectList.contains(id)) {
      selectList.remove(id);
    }else{
      selectList.add(id);
    }
    setState(() {
      selectList = selectList;
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
                      title: Text( widget.name,style: TextStyle(fontSize: _adapt.setFontSize(18))),
                      centerTitle: true,
                      backgroundColor: Colors.transparent
                    ),
                    body: Container(
                      color: Color.fromRGBO(4,38,83,0.35),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index){
                                  var item = list[index];
                                  return Items(data: item, callCback: this.itemClick, selectList: selectList);
                              },
                            )
                          ),
                          ButtonsComponents( rightShow: false,  leftName: '确定',cbackLeft: (){
                              Navigator.pop(context, selectList);
                          })
                        ],
                      )
                    )
              )
            );
  }
}

class Items extends StatelessWidget {
  Items({Key key, this.data, this.callCback, this.selectList}) : super(key: key);
  final Map data;
  Function callCback;
  Set selectList;
  // 获取选中的组件样式
  Container getIsSelect(id, _adapt){
      if (selectList.contains(id)) {
        return Container(
                width: _adapt.setWidth(16.0),
                height: _adapt.setWidth(16.0),
                margin: EdgeInsets.only(right: _adapt.setWidth(18.0), left: _adapt.setWidth(6.0)),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(55, 148, 255, 1),
                  borderRadius: BorderRadius.all(Radius.circular(_adapt.setWidth(8.0)))
                ),
                child: Icon(Icons.done, size: _adapt.setFontSize(13.0) ),
              );
      }else{
        return Container(
                width: _adapt.setWidth(16.0),
                height: _adapt.setWidth(16.0),
                margin: EdgeInsets.only(right: _adapt.setWidth(18.0), left: _adapt.setWidth(6.0)),
                decoration: BoxDecoration(
                  border: Border.all(width: _adapt.setWidth(1.0), color: white_name_color),
                  borderRadius: BorderRadius.all(Radius.circular(_adapt.setWidth(8.0)))
                ),
              );
    }
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    return Container(
      child: FlatButton(
        onPressed: (){
          if (callCback != null) {
              callCback(data['userID']);
          }
        },
        child: Container( //items
          height: _adapt.setHeight(46),
          padding: EdgeInsets.only(left: _adapt.setWidth(15)),
          child: Column(
            children: <Widget>[
              Container( //内容
                height: _adapt.setHeight(45),
                padding: EdgeInsets.only(right: _adapt.setWidth(10)),
                child: Row(
                  children: <Widget>[
                    getIsSelect(data['userID'], _adapt),
                    Expanded(
                      child: Text( data['userName'], style: TextStyle(color: white_name_color, fontSize: _adapt.setFontSize(16))),
                    ),
                  ],
                ),
              ),
              Container( //下边线
                height: _adapt.setHeight(1),
                color: Color.fromRGBO(1, 13, 29, 1),
              )
            ],
          ),
        )
      )
    );
  }
}