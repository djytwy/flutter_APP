/**
 * 抽屉页的二级多选项
 * 参数:
 *  checked: 是否选中
 *  label: 文案
 *  clickCb: 点击的回调函数
 * author: djytwy on 2019-11-12 15:52
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawPageSecond extends StatefulWidget {

  DrawPageSecond({
    Key key,
    this.checked,
    this.label,
    this.clickCb,
  }):super();

  final checked;
  final label;
  final clickCb;

  @override
  _DrawPageSecondState createState() => _DrawPageSecondState();
}

class _DrawPageSecondState extends State<DrawPageSecond> {

  // 触发点击的函数
  void _check() {
    print(widget.label);
    widget.clickCb(widget.label);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _check,
      child: Row(
        children: <Widget>[
          // label
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(20)),
              alignment: Alignment.centerLeft,
              child: Text(widget.label, style: widget.checked ?
                TextStyle(color: Colors.blue) : TextStyle(color: Colors.white54)),
            ),
          ),
          // 状态
          Expanded(
            flex: 1,
            child: Offstage(
              offstage: !widget.checked,
              child: Container(
                padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(15)),
                alignment: Alignment.centerRight,
                child: Icon(Icons.check,color: Colors.blue),
              ),
            ),
          )
        ],
      ),
    );
  }
}
