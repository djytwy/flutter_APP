// 页面的列表按钮
import 'package:flutter/material.dart';
import '../../../utils/util.dart';

class ButtonBars extends StatefulWidget {
  ButtonBars({Key key, this.title, this.number, this.callCback}) : super(key: key);
  String title = '';
  int number = 0;
  Function callCback;
  _ButtonBar createState() => _ButtonBar();
}
class _ButtonBar extends State<ButtonBars> {
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    int number = widget.number;
    // 设置 设计图和设备的 宽高比例
    var _adapt = SelfAdapt.init(context);
    return Container(
        width: double.infinity,
        height: _adapt.setHeight(48),
        // color: Color.fromRGBO(4,38,83,0.35),
        margin: EdgeInsets.only(top: _adapt.setHeight(10), left: _adapt.setWidth(10), right: _adapt.setWidth(10)),
        padding: EdgeInsets.only(left: _adapt.setWidth(10), right: _adapt.setWidth(5)),
        decoration: new BoxDecoration(
          color: Color.fromRGBO(4,38,83,0.35),
          borderRadius: new BorderRadius.all(new Radius.circular(_adapt.setWidth(4))),
        ),
        child: GestureDetector(
          onTap: ()=>{},
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: GestureDetector(
                    onTap: (){
                      if (widget.callCback is Function) {
                          widget.callCback();
                      }
                    },
                    child: Center(
                      child:  Text('$title', style: TextStyle(color: Color.fromRGBO(196,236,255,1)))
                    )
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Offstage(
                  offstage: number > 0 ? false : true, // 是否隐藏该子组件
                  child: Container(
                    padding: _adapt.setMargin(2),
                    constraints: BoxConstraints( //设置最小宽度 最小高度
                      minHeight: _adapt.setHeight(15),
                      minWidth: _adapt.setWidth(15),
                    ),
                    child: Text('$number', textAlign: TextAlign.center, style: TextStyle(fontSize: _adapt.setFontSize(12),color: Color.fromRGBO(255,255,255,1))),
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(237, 74, 74, 1),
                      borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                    )
                  ),
                ),
              )
            ],
          )
        )
      );
  }
}