import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/pageHttpInterface/workOrderContent.dart';
import '../../voice/xf_voice.dart';

class Scheduing extends StatefulWidget {
  Scheduing({Key key}) : super(key: key);

  _ScheduingState createState() => _ScheduingState();
}

class _ScheduingState extends State<Scheduing> {
  // bool isLoading = false;
  // String ifyResult = "暂无数据";

  // void getVoiceResult(result) {
  //   setState(() {
  //     ifyResult = result;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    // setScreen();
    super.initState();
  }

  void setScreen() {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
  }

  void showMySimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
        return new SimpleDialog(
          title: new Text("SimpleDialog"),
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Container(
              height: ScreenUtil.getInstance().setHeight(1334),
              width: ScreenUtil.getInstance().setWidth(900),
              color: Colors.lightBlue,
              child: Center(
                child: Text('这是数据'),
              )
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: !isLoading? 
    //   Center(
    //     child: RaisedButton(
    //       child: Text('按下loading....'),
    //       onPressed: (){
    //         setState(() {
    //             isLoading = true;
    //           });
    //         // getData('1','33').then((val) {
    //         //   setState(() {
    //         //     isLoading = false;
    //         //   });
    //         // });
    //       },
    //     )
    //   ) :
    //   CircularProgressIndicator()
    // );
    // return Center(
    //   child: Column(
    //     children: <Widget>[
    //       // 调用语音识别
    //       VoiceRecognize(voiceCallback: (r) => getVoiceResult(r)),
    //       // 语音识别结果
    //       Text(ifyResult,style: TextStyle(color: Colors.white54),),
    //     ],
    //   )
    // );
    return Container(
      child: RaisedButton(
        child: Text('点我试试'),
        onPressed: (){showMySimpleDialog(context);},
      )
    );
  }
}