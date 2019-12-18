import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/TelAndSmsService.dart';    // 导入服务中打电话功能
import '../services/ServiceLocator.dart';      // 导入服务接口

class ListItem extends StatelessWidget {
  ListItem({
    Key key, 
    this.title,
    @required this.content,
    this.phone=true,
    this.phoneNum,
    this.color,
    this.background,
    this.border=false,
    this.marginTop,
    this.labelWidget
  }) : super(key: key);

  final TelAndSmsService _service = locator<TelAndSmsService>();    // 使用打电话功能
  final title;                  // 每一行的title
  final content;                // 每一行的内容
  final phone;                  // 电话标志 如果false则显示电话
  final phoneNum;               // 电话号码 电话标志为true时使用
  final color;                  // 字体颜色(完成时限用)
  final border;                 // 是否显示下边框
  final background;             // 背景色
  final marginTop;              // 上边距
  Widget labelWidget;            // 传入的label

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Container(
      margin: EdgeInsets.only(top: marginTop != null ? marginTop : 0.0),
      padding: EdgeInsets.fromLTRB(
        ScreenUtil.getInstance().setWidth(30), 
        ScreenUtil.getInstance().setWidth(32), 
        ScreenUtil.getInstance().setWidth(30), 
        ScreenUtil.getInstance().setWidth(32), 
      ),
      decoration: BoxDecoration(
        color: background != null ? background : Color.fromARGB(100, 12, 33, 53),
        border: Border(
          bottom: BorderSide(
            width: ScreenUtil.getInstance().setHeight(1),
            color: border? Color.fromARGB(255, 1, 13, 29) : Color.fromARGB(0, 1, 13, 29)
          )
        )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(title == null ? "" : title, textAlign: TextAlign.left,style: TextStyle(color: color != null ? color : Colors.white)),
            ),
          ),
          Offstage(
            offstage: phone || content == '暂未处理',
            child: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                color: Colors.lightBlue,
                onPressed: (){ _service.call(phoneNum);},
                icon: Image(image: new AssetImage('assets/images/phone.png'), width: ScreenUtil.getInstance().setWidth(32),height: ScreenUtil.getInstance().setWidth(32),fit: BoxFit.cover,),
              ),
            ),
          ),
          labelWidget == null ? Text(''): labelWidget,
          Text(content == null ? '暂无' : content, textAlign: TextAlign.right,style: TextStyle(color: color != null ? color : Colors.white))
        ],
      ),
    );
  }
}