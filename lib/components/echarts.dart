import 'package:flutter/material.dart';
import 'package:flutter_echart/flutter_echart.dart';

class Echarts extends StatefulWidget {
  Echarts({Key key}) : super(key: key);

  _EchartsState createState() => _EchartsState();
}

class _EchartsState extends State<Echarts> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var option = {
      "xAxis": {
        "type": "category",
        "data": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
      },
      "yAxis": {"type": "value"},
      "series": [
        {
          "data": [820, 932, 901, 934, 1290, 1330, 1320],
          "type": "line"
        }
      ]
    };
    
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Native WebView as Widget'),
        ),
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Text('Native WebView as Widget\n\n'),
              new Container(
                child: EchartView(height: 300, data: option),
                height: 300.0,
                width: 500.0,
              ),
            ],
          ),
        )
      ),
    );
  }
}