/**
 * 抽屉页的单选按钮组件
 * 参数：
 *  clickCb: 点击按钮的回调函数
 *  item: 按钮的信息
 *  checked: 是否选中
 * author: djytwy on 2019-11-12 14:19
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawPageButton extends StatefulWidget {
  DrawPageButton({
    Key key,
    this.clickCb,
    this.item,
    this.checked,
  }):super();
  final clickCb;
  final item;
  final checked;

  @override
  _DrawPageButtonState createState() => _DrawPageButtonState();
}

class _DrawPageButtonState extends State<DrawPageButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _clickCb,
      child: Container(
        height: ScreenUtil.getInstance().setHeight(40),
        width: ScreenUtil.getInstance().setWidth(110),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: widget.checked == true ? Colors.blue : Colors.transparent,
              width: widget.checked == true ?
                ScreenUtil.getInstance().setWidth(2) : 0.0
            )
          ),
          color: widget.checked == true ? Color.fromARGB(255, 29, 57, 87) : Colors.transparent
        ),
        child: Center(
          child: Text(widget.item["label"], style: TextStyle(color: Colors.white70)),
        ),
      ),
    );
  }

  void _clickCb() {
    widget.clickCb(widget.item);
  }
}
