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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index){
          var item = data[index];
          return Container(
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
          );
        }
      )
    );
  }
}