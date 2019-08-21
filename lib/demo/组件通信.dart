import 'package:flutter/material.dart';
import '../components/stateFultest.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String data = '';
  String dataToCom = '传递给组件2的值';

  void onChanged(val) {
    setState(() {
      data = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '父子组件通信',
      home: Scaffold(
        appBar: AppBar(title: Text('测试父子组件通信')),
        body: Center(
          child: Column(
            children: <Widget>[
              ChildrenTest(dataFromParent: dataToCom, testCallback: (v) => onChanged(v)),
              Text(data)
            ],
          ),
        ),
      ),
    );
  }
}