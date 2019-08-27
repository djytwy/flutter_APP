import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../services/ServiceLocator.dart';
import '../../services/TelAndSmsService.dart';
import '../../services/pageHttpInterface/ReportFix.dart';
// 组件
import '../../voice/xf_voice.dart';
import '../../components/echarts.dart';
import '../../components/imagePicker.dart';
import '../../pages/reportFix/ReportFix.dart';    // 报修工单
import '../workOrder/newWorkOrder.dart';          // 新工单
import '../workOrder/workOrderContent.dart';  // 工单内容页
import '../workOrder/detailWorkOrder.dart';   // 工单详情页
import '../workOrder/inTimeWorkOrder.dart';   // 即时工单

import '../../pages/Login.dart';
import '../../pages/ModifyPassword.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
    
  // 语音识别的结果
  String ifyResult = '暂无结果';

  // get的数据
  String content = '这里是html';

  // 图片
  Future <File> _imgFile;

  // 发信息，打电话的服务
  final TelAndSmsService _service = locator<TelAndSmsService>();
  final String number = "10086";

  void getVoiceResult(result) {
    setState(() {
      ifyResult = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('首页', style: TextStyle(fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.transparent
      ),
      body: Column(
       children: <Widget>[
          // 路由
          Center(child: ButtonList()),
          // 调用语音识别
          // VoiceRecognize(voiceCallback: (r) => getVoiceResult(r)),
          // 语音识别结果
          // Text(ifyResult),
          // 打电话
          // RaisedButton(
          //   onPressed: () => _service.call(number),
          //   child: Text('测试打电话功能！'),
          // ),
          // RaisedButton(
          //   child: Text('发起请求'),
          //   onPressed: (){_getHtml();},
          // ),
          // SingleChildScrollView(
          //   child: Text(content),
          // ),
        ]
      ),
    );
  }
 _getHtml(){
    getData().then((val) {
      setState(() {
        content = val;
      });
    });
  }

  void _getImgUrl(Future file) async{
    setState(() {
      _imgFile = file;
    });
  }
}

class WebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "http://www.taobao.com/",
      appBar: AppBar(title: new Text('webview')),
    );
  }
}

class ButtonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // RaisedButton(
        //   child: Text('进入webview'),
        //   onPressed: (){
        //     Navigator.push(context, MaterialPageRoute(
        //       builder: (context) => new WebViewPage())
        //     );
        //   },
        // ),
        // RaisedButton(
        //   child: Text('echarts'),
        //   onPressed: (){
        //     Navigator.push(context, MaterialPageRoute(
        //       builder: (context) => new Echarts())
        //     );
        //   },
        // ),
        RaisedButton(
          child: Text('进入工单页面'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ReportFix()
            ));
          },
        ),
        RaisedButton(
          child: Text('新工单列表'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => NewWorkOrder()
            ));
          },
        ),
        RaisedButton(
          child: Text('进入登录页面'),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => new Test()
            ));
          },
        ),
        RaisedButton(
          child: Text('进入修改密码页面'),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => new ModifyPassword()
            ));
          },
        ),
        RaisedButton(
          child: Text('进入工单内容页'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => WorkOrderContent()
            ));
          },
        ),
        RaisedButton(
          child: Text('详情页'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => DetailWordOrder(orderID: 1231,)
            ));
          },
        ),
        RaisedButton(
          child: Text('即时工单'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => InTimeWorkOrder(orderID: 12321,)
            ));
          },
        )
      ],
    );
    
  }
}

// void main() async {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   MyApp({Key key}) : super(key: key);

//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String content = '';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'test',
//       home: Scaffold(
//         appBar: AppBar(title: Text('http测试')),
//         body: Column(
//           children: <Widget>[
//             RaisedButton(
//               child: Text('发起请求'),
//               onPressed: _get,
//             ),
//             SingleChildScrollView(
//               child: Text(content),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   _get(){
//     testGet().then((val) {
//       setState(() {
//         content=val;
//       });
//     });
//   }
// }

// class MyApp extends StatefulWidget {
//   MyApp({Key key}) : super(key: key);

//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Future <File> _imgFile;
//   final request = Request();
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'test',
//       home: Scaffold(
//         appBar: AppBar(title: Text('测试图片上传')),
//         body: Column(
//           children: <Widget>[
//             FutureBuilder<File>(
//               future: _imgFile,
//               builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
//                   // request.httpGet('http://192.168.3.51/', '');
//                   // request.httpPost('http://192.168.3.51/up_photo', '', snapshot.data,'file');
//                   return Image.file(snapshot.data);
//                 } else {
//                   return Text(
//                     'You have not yet picked an image.',
//                     textAlign: TextAlign.center,
//                   );
//                 }
//               }
//             ),
//             CustomImagePicker(imageCallback: (file) => _getImgUrl(file))
//           ],
//         ),
//       )
//     );
//   }

//   void _getImgUrl(Future file) async{
//     setState(() {
//       _imgFile = file;
//     });
//     Response response = await Dio().get("http://192.168.3.51/");
//     print(response);
//     // await request.httpGet('http://192.168.3.51/', '');
//   }
// }