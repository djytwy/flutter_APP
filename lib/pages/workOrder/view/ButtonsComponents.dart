import 'package:flutter/material.dart';
import '../../../utils/util.dart';


class ButtonsComponents extends StatelessWidget {
  ButtonsComponents({Key key, this.cbackLeft, this.cbackRight, this.leftName, this.rightName, this.leftShow = true, this.rightShow = true}) : super(key: key);
  Function cbackLeft;
  Function cbackRight;
  String leftName;
  String rightName;
  bool leftShow;
  bool rightShow;

  // 获取按钮列表组件
  List<Widget> getList(context) {
    var _adapt = SelfAdapt.init(context);
    List<Widget> list = [];
    if (leftShow) {
      list.add(Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(right: _adapt.setWidth(8)),
              child:RaisedButton(
                onPressed: (){
                  this.cbackLeft();
                },
                child: Text(leftName, style: TextStyle(fontSize: _adapt.setFontSize(18), fontWeight: FontWeight.w300)),
                textColor: Colors.white,
                color: Color.fromRGBO(113, 166, 241, 1),
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    ),
              )
          )
        ));
    }
    if (rightShow) {
      list.add(
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: _adapt.setWidth(8)),
            child: RaisedButton(
              onPressed: (){
                cbackRight();
              },
              child: Text(rightName, style: TextStyle(fontSize: _adapt.setFontSize(18), fontWeight: FontWeight.w300)),
              textColor: Colors.white,
              color: Color.fromRGBO(113, 166, 241, 1),
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
            )
          )
        )
      );
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    return Container(
          margin: EdgeInsets.only(top: _adapt.setHeight(20)),
          child: Row(
            children: getList(context)
          ),
          padding: EdgeInsets.only(left: _adapt.setWidth(15), right: _adapt.setWidth(15), top: _adapt.setHeight(15), bottom: _adapt.setHeight(15)),
          width: double.infinity,
          height: _adapt.setHeight(74),
          decoration: BoxDecoration(
            color: module_background_color,
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 20, 37, 1), offset: Offset(0.0, -2.0), blurRadius: 1.0),
            ]
          )
        );
  }
}