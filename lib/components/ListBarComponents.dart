import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/util.dart';


class ListBarComponents extends StatefulWidget {
  ListBarComponents({Key key, this.name, this.value, this.ishidePhone, this.tel, this.rightClick}) : super(key: key);
  final String name;
  final String value;
  bool ishidePhone = true; //是否隐藏电话图标
  final String tel;
  Function rightClick;
  _ListBarComponentsState createState() => _ListBarComponentsState();
}
class _ListBarComponentsState extends State<ListBarComponents> {
  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    String value = widget.value;
    bool ishidePhone = widget.ishidePhone;
    String tel = widget.tel;

    // 设置 设计图和设备的 宽高比例
    var _adapt = SelfAdapt.init(context);
    if (widget.rightClick != null) {
      return Container(
        height: _adapt.setHeight(45),
        width: double.infinity,
        padding: EdgeInsets.only(right: _adapt.setWidth(15)),
        child: Row(children: <Widget>[
          Expanded(
            child: Text('$name',style: TextStyle(color: white_name_color)),
            flex: 1,
          ),
          Container(
            child: GestureDetector(
                onTap: (){
                  widget.rightClick();
                },
                child: Row(
                  children: <Widget>[
                    Text(value == null || value == ''? '请选择': value, style: TextStyle(color: white_color)),
                    Icon(Icons.keyboard_arrow_right, color: Colors.white)
                  ],
                )
            )
          )
        ]
      ),
    );
    }else{
      return Container(
          height: _adapt.setHeight(45),
          width: double.infinity,
          padding: EdgeInsets.only(right: _adapt.setWidth(15)),
          child: Row(children: <Widget>[
            Expanded(
              child: Text('$name',style: TextStyle(color: white_name_color)),
              flex: 1,
            ),
            Offstage(
              offstage: ishidePhone == false ? true : false,
              child: Text('$value',textAlign: TextAlign.right ,style: TextStyle(color: white_color)),
            ),
            Offstage(
              offstage: ishidePhone == false ? false : true,
              child: Container(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          color: Colors.lightBlue,
                          onPressed: (){
                            if (tel != null) {
                              launch("tel:$tel");
                            }else{
                              showTotast('暂无电话号码信息！');
                            }
                          },
                          icon: Image(image: new AssetImage('assets/images/phone.png'), width: _adapt.setWidth(16),height: _adapt.setWidth(16)),
                        ),
                      ),
                      Text('$value',style: TextStyle(color: white_color))
                    ]
                )
              )
            ),
          ]
        ),
      );
    }
  }
}