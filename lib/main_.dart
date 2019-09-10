import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:catcher/catcher_plugin.dart';

void main() {
  // CatcherOptions debugOptions =
  //     CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  // CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
  //   EmailManualHandler(["676534074@qq.com"])
  // ]);

  // Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
  // _setTargetPlatformForDesktop();
  // setCustomErrorPage();
  runApp(MyApp());
}

// void setCustomErrorPage() {
//   ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
//     print(flutterErrorDetails.toString());
//     return Center(
//       child: Text('出错了！'),
//     );
//   };
// }

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String a= '1231231fggg';
  dynamic b = [];

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      home: Scaffold(
        appBar: AppBar(title: Text('表头'),),
        body: Scaffold(
          body: Column(
            children: <Widget>[
              Text('数据1'),
              Text('数据2'),
              Text(b[10]),
              // RaisedButton(
              //   child: Text(a),
              //   onPressed: (){
              //     setState(() {
              //       a = b[10];
              //     });
              //   },
              // )
            ],
          )
        ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   String te = '1231';
//   dynamic a = [];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: Catcher.navigatorKey,
//       builder: (BuildContext context, Widget widget) {
//         Catcher.addDefaultErrorWidget(
//             showStacktrace: true,
//             customTitle: "Custom error title",
//             customDescription: "Custom error description");
//         return widget;
//       },
//       home: Container(
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//           ),
//           body: ChildWidget(),
//           // body: Column(
//           //   children: <Widget>[
//           //     Container(
//           //       margin: EdgeInsets.all(20.0),
//           //       child: ChildWidget(b: te),
//           //     ),
//           //     RaisedButton(
//           //       child: Text('点我报错'),
//           //       onPressed: () => generateError()
//           //     )
//           //   ],
//           // ) 
//         ),
//       )
//     );
//   }

//   generateError() async {
//     throw "Test exception";
//   }
// }

// class ChildWidget extends StatelessWidget {

//   ChildWidget({Key key, this.b='test'}) : super(key: key);
//   final b;
//   dynamic a = [];

//   @override
//   Widget build(BuildContext context) {
//     String n = a[3];
//     return Container(
//       child: FlatButton(
//         child: Text("Generate error: $n"),
//         onPressed: generateError
//       )
//     );
//   }

//   generateError() {
//     throw "Test exception";
//   }
// }