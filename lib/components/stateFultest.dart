import 'package:flutter/material.dart';

class ChildrenTest extends StatefulWidget {
  ChildrenTest({Key key, this.dataFromParent, this.testCallback}):super(key: key);
  final ValueChanged<String> testCallback;
  String dataFromParent;

  @override
  _ChildrenTestState createState() => _ChildrenTestState();
}

class _ChildrenTestState extends State<ChildrenTest> {

  String inputText = '来自子组件！';
  String data = '';

  @override
  void initState() {
    data = widget.dataFromParent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(data),
          color: Colors.greenAccent,
        ),
        Container(
          child: RaisedButton(
            child: Text('点击向父组件发信息!'),
            onPressed: _test,
          ),
        )
      ],
    );
  }

  void _test() {
    widget.testCallback('$inputText');
  }
}