// 抄送部门
import 'package:flutter/material.dart';
import '../../utils/util.dart';

// 页面
import './copier.dart';

// 组件
import '../../components/ButtonsComponents.dart';

class CopierDepartment extends StatefulWidget {
  CopierDepartment({Key key, this.data}) : super(key: key);
  List data;
  _CopierDepartmentState createState() => _CopierDepartmentState();
}
class _CopierDepartmentState extends State<CopierDepartment> {

  List data = [];
  @override void initState() {
    super.initState();
    List list = [];
    widget.data.forEach((item){
      list.add(item);
    });
    setState(() {
      data = list;
    });
  }
  // 列表回调方法
  void itemClick(selectList, name){
    var list = [];
    data.forEach((item){
      // 创建新的 map 防止 直接修改 影响上页面传来的数据
      var items = new Map();
      if (item['userName'] == name) {
        items['userName'] = name;
        items['selectList'] = selectList;
        items['childs'] = item['childs'];
        list.add(items);
      }else{
        list.add(item);
      }
    });
    setState(() {
      data = list;
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
                      title: Text('选择抄送人',style: TextStyle(fontSize: _adapt.setFontSize(18))),
                      centerTitle: true,
                      backgroundColor: Colors.transparent
                    ),
                    body: Container(
                      color: Color.fromRGBO(4,38,83,0.35),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index){
                                  var item = data[index];
                                  return Items(data: item, callCback: this.itemClick);
                              },
                            )
                          ),
                          ButtonsComponents( rightShow: false,  leftName: '确定',cbackLeft: (){
                            List list = format(data);
                            if (list.length > 10) {
                              showTotast('抄送人不能大于10');
                            }else{
                               Navigator.pop(context, { 'data': data, 'selects':  list});
                            }
                          })
                        ],
                      )
                    )
              )
            );
  }
}
// 处理数据格式
List format(data){
  if (data.length == 0) {
    return [];
  }
  List list = [];
  data.forEach((item){
    if (item['selectList'] != null) {
        item['selectList'].forEach((itemx){
            list.add(itemx);
        });
    }
  });
  return list;
}
class Items extends StatelessWidget {
  Items({Key key, this.data, this.callCback}) : super(key: key);
  final Map data;
  Function callCback;

  // 获取选中的组件样式
  Container getIsSelect(data, _adapt){
      if (data['selectList'] != null && data['selectList'].length > 0 ) {
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
    var name = '';
    if (data != null) {
      name = data['userName'];
    }
    return Container( //items
          height: _adapt.setHeight(46),
          padding: EdgeInsets.only(left: _adapt.setWidth(15)),
          child: Column(
            children: <Widget>[
              Container( //内容
                height: _adapt.setHeight(45),
                padding: EdgeInsets.only(right: _adapt.setWidth(10)),
                child: Row(
                  children: <Widget>[
                    getIsSelect(data, _adapt),
                    Expanded(
                      child: Text( name, style: TextStyle(color: white_name_color, fontSize: _adapt.setFontSize(16))),
                    ),
                    GestureDetector(
                      onTap: () async{
                        var val = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Copier(data: data, name: name)
                              ));
                        if (val != null) {
                          callCback(val, name);
                        }
                      },
                      child: Row(
                          children: <Widget>[
                            Text('下一级', style: TextStyle(color: white_name_color, fontSize: _adapt.setFontSize(16))),
                            Icon(Icons.keyboard_arrow_right,  color: Color.fromRGBO(173, 216, 255, 1))
                          ],
                        )
                    )
                  ],
                ),
              ),
              Container( //下边线
                height: _adapt.setHeight(1),
                color: Color.fromRGBO(1, 13, 29, 1),
              )
            ],
          ),
        );
  }
}