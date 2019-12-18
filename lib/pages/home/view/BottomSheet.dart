/**
 * 点击人员数量展示的BottomSheet
 * 参数：
 *  online：在线人数
 *  outline: 离线人数
 *  data:传入的人员的数据
 * author: djytwy on 2019-11-28 15:19
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeopleBottomSheet extends StatelessWidget {
  PeopleBottomSheet({
    Key key,
    this.online,
    this.outline,
    this.data,
  }):super();
  final online;
  final outline;
  final data;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 672, allowFontScaling: true)..init(context);
    return Container(
      height: ScreenUtil.instance.setHeight(345.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(4, 38, 83, 0.35),
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        children: <Widget>[
          // 返回按钮
          Container(
            child: FlatButton(
              onPressed: (){Navigator.pop(context);},
              child: Text('返回',style: TextStyle(color: Color.fromARGB(255, 117, 128, 138))),
              padding: EdgeInsets.only(left: 0,right: 20),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 8, 30, 49)
            ),
            width: double.infinity,
            alignment: Alignment.centerLeft,
          ),
          // 在线，离线人员
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil.instance.setWidth(21),
                    top: ScreenUtil.instance.setWidth(20),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '在线：',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white70,fontSize: ScreenUtil.instance.setSp(18)),
                      ),
                      Text(
                        '${online.toString()} 人',
                        style: TextStyle(color: Colors.cyanAccent,fontSize: ScreenUtil.instance.setSp(18),fontWeight: FontWeight.w100),
                      ),
                    ],
                  )
                )
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    right: ScreenUtil.instance.setWidth(21),
                    top: ScreenUtil.instance.setWidth(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '离线：',
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white70,fontSize: ScreenUtil.instance.setSp(18)),
                      ),
                      Text(
                        '${outline.toString()} 人',
                        style: TextStyle(color: Colors.cyanAccent,fontSize: ScreenUtil.instance.setSp(18),fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
          // 分割线
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              right: ScreenUtil.instance.setWidth(20),
              left: ScreenUtil.instance.setWidth(20),
              bottom: ScreenUtil.instance.setHeight(10),
              top: ScreenUtil.instance.setHeight(10)
            ),
            color: Colors.black,
            height: ScreenUtil.instance.setHeight(1),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _genView(),
              ),
            )
          ),
        ],
      )
    );
  }

  List<Widget> _genView(){
    List<Widget> _list = [];
    for(var _index in data) {
      Widget _item = Container(
        child: Column(
          children: _genItems(_index['children'], _index['label']),
        )
      );
      _list.add(_item);
    }
    return _list;
  }

  List<Widget> _genItems(listData,title){
    List<Widget> _itemsList = [];
    // bottomSheet其中每一个职位的title
    Widget _titleWidget = Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil.instance.setWidth(21),
        0,
        0,
        ScreenUtil.instance.setHeight(16)
      ),
      child: Text(
        '$title :',
        style: TextStyle(color: Color.fromARGB(255, 113, 166, 255),fontSize: ScreenUtil.instance.setSp(18))
      ),
    );
    _itemsList.add(_titleWidget);
    for ( var _indexItem in listData ) {
      Widget _itemWidget = Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(
          ScreenUtil.instance.setWidth(21),
          0,
          ScreenUtil.instance.setWidth(20),
          ScreenUtil.instance.setHeight(16)
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                _indexItem["label"],
                style: TextStyle(color: Color.fromARGB(230,118,155,220),fontSize: ScreenUtil.instance.setSp(15)),
              ),
            ),
            Expanded(
              child: _indexItem["status"] == 1 ? StatusButton(label: '在线',color: Color.fromARGB(255, 74, 226, 131),) : StatusButton(label: '离线',color: Color.fromARGB(255, 45, 67, 101)),
            )
          ],
        )
      );
      _itemsList.add(_itemWidget);
    }
    // 分割线
    Widget _line = Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        left: ScreenUtil.instance.setWidth(20),
        right: ScreenUtil.instance.setWidth(20),
        bottom: ScreenUtil.instance.setWidth(10),
      ),
      color: Colors.black,
      height: ScreenUtil.instance.setHeight(1),
    );
    _itemsList.add(_line);
    return _itemsList;
  }
}

class StatusButton extends StatelessWidget {
  StatusButton({
    Key key,
    this.color,
    this.label
  }):super();
  final color;
  final label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.all(Radius.circular(3))
        ),
        width: ScreenUtil.instance.setWidth(40),
        height: ScreenUtil.instance.setHeight(20),
        child: Center(
          child: Text(this.label,style: TextStyle(color: Colors.white)),
        )
      )
    );
  }
}

