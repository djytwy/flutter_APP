import 'package:flutter/material.dart';
import '../../../utils/util.dart';


class MultipleRowTexts extends StatelessWidget {
  MultipleRowTexts({Key key, this.name, this.value}) : super(key: key);
  final String name;
  final String value;
  @override
  Widget build(BuildContext context) {
    // 设置 设计图和设备的 宽高比例
    var _adapt = SelfAdapt.init(context);
    return Container(// 内容模块
          child: Column(children: <Widget>[
              Text('$name', style: TextStyle(color: white_name_color)),
              Container(
                child: Text('$value', style: TextStyle( color: Colors.white)),
                margin: EdgeInsets.only(top: _adapt.setHeight(10.0)),
                constraints: BoxConstraints( //设置最小宽度 最小高度
                  minHeight: _adapt.setHeight(57),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start
          ),
          padding: EdgeInsets.only(left: _adapt.setWidth(15), right: _adapt.setWidth(15), top: _adapt.setHeight(15), bottom: _adapt.setHeight(15)),
          width: double.infinity,
          color: module_background_color,
          margin: EdgeInsets.only(top: _adapt.setHeight(8)),
        );
  }
}