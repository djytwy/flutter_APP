import 'package:flutter/material.dart';
import '../../../utils/util.dart';
import '../../../config/serviceUrl.dart';

class ImageList extends StatelessWidget {
  ImageList({Key key, this.data}) : super(key: key);
  final List data;
  @override
  Widget build(BuildContext context) {
    var _adapt =  SelfAdapt.init(context);
    return Container(
              margin: EdgeInsets.only(top: _adapt.setHeight(8)),
              height: 133,
              child: ListView(
                //设置水平方向排列
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: _adapt.setWidth(5), right: _adapt.setWidth(5)),
                children: fillData(data, context)
              )
          );
  }
}
List<Widget> fillData(data, context){
    var _adapt =  SelfAdapt.init(context);
    List<Widget> list = [];//先建一个数组用于存放循环生成的widget
    for(var item in data){
        list.add(
          Container(
            width: _adapt.setWidth(173),
            margin: EdgeInsets.only(right: _adapt.setWidth(5), left: _adapt.setWidth(5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image(
                image: NetworkImage(serviceUrl + item["picUrl"]),
                width: double.infinity,
                height: _adapt.setHeight(128),
                fit: BoxFit.cover,
              )
            )
          )
        );
    }
    return list;
}