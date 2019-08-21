import 'package:flutter/material.dart';

// class ChildrenTest extends StatefulWidget {
//   ChildrenTest({Key key, this.testCallback}):super(key: key);
//   final ValueChanged<String> testCallback;
//   @override
//   _ChildrenTestState createState() => _ChildrenTestState();
// }

// class _ChildrenTestState extends State<ChildrenTest> {

//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       child: Text('点击测试'),
//       onPressed: (){_test();},
//     );
//   }

//   _test(){
//     testCallback('来自于子组件！');
//   }
// }

class ChildrenA extends StatelessWidget {
  //定义接收父类回调函数的指针
  final ValueChanged<String> ChildrenACallBack;
  ChildrenA({Key key,this.ChildrenACallBack}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (){
        //调用回调函数传值
        ChildrenACallBack('1231');
      },
      child: new Container(
          width: 80,
          height: 80,
          color: Colors.green,
          child: new Text('ChildrenA'),
      ),
    );
  }
}
