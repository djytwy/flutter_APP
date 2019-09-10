import 'package:flutter/material.dart';
import '../utils/util.dart';

// 分割线
class SplitLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    return Container(  
        width: double.infinity,
        height: _adapt.setHeight(1), 
        color: Color.fromRGBO(1, 13, 29, 1),
      );
  }
}