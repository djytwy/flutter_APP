import 'package:flutter/material.dart';
import '../utils/util.dart';

// 备注录入
class NoteEntry extends StatelessWidget {
  NoteEntry({Key key, this.title = '备注', this.change}) : super(key: key);
  String title;
  Function change;
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    return Container(// 内容模块
            child: Column(children: <Widget>[
                Text(title , style: TextStyle(color: white_name_color)),
                Container(
                  child: TextField(
                    maxLength: 50,
                    maxLines: 3,
                    cursorColor: Colors.white, //光标颜色
                    onChanged: (newValue) {
                      if (change != null) {
                        this.change(newValue);
                      }
                    },
                    style: TextStyle(
                      color: white_color,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none, // 边框样式
                        hintText: '请输入备注，最多50字',
                        hintStyle: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                        helperStyle: TextStyle(color: Color.fromRGBO(150, 150, 150, 1))
                    )
                  )
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