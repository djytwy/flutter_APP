import 'package:flutter/material.dart';
import 'dart:async';
import 'package:xfvoice/xfvoice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String iflyResultString = '按下开始识别，松手结束识别';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final voice = XFVoice.shared;
    voice.init(appIdIos: '5d53633c', appIdAndroid: '5d53633c');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    param.asr_ptt = '0';
    param.asr_audio_path = 'xme.pcm';
    param.result_type = 'plain';
    voice.setParameter(param.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('测试科大讯飞的语音识别'),
        ),
        // body: Center(
        //   child: GestureDetector(
        //     child: Text(iflyResultString),
        //     onTapDown: _onTapDown,
        //     onTapUp: _onTapUp,
        //   ),
        // ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('点击开始说话'),
                onPressed: (){_buttonOne();},
              ),
              Text(iflyResultString),
              RaisedButton(
                child: Text('点击结束说话'),
                onPressed: (){_buttonTwo();},
              )
            ],
          )
        ),
      ),
    );
  }

  onTapDown(TapDownDetails detail) {
    setState(() {
      iflyResultString = '说话中.....';
    });
    final listen = XFVoiceListener(
      onVolumeChanged: (volume) {
        print('$volume');
      },
      onResults: (String result, isLast) {
        if (result.length > 0) {
          print('这个是result： $result');
          setState(() {
            iflyResultString = result;
          });
        }
      },
      onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
        setState(() {
          // iflyResultString += '\n$filePath';
        });
      }
    );
    XFVoice.shared.start(listener: listen);
  }

  onTapUp(TapUpDetails detail) {
    XFVoice.shared.stop();
    // setState(() {
    //   iflyResultString = '按下说话';
    // });
  }

  _onTapDown(TapDownDetails details) {
    print('按下了！');
    setState(() {
      iflyResultString = '按下的文字';
    });
  }

  _onTapUp(TapUpDetails details) {
    print('松开了！');
    setState(() {
      iflyResultString = '松开';
    });
  }

  _buttonOne() {
    print('说话按键');
    setState(() {
      iflyResultString = '开始';
    });
    final listen = XFVoiceListener(
      onVolumeChanged: (volume) {
        print('$volume');
      },
      onResults: (String result, isLast) {
        if (result.length > 0) {
          print('这个是result： $result');
          setState(() {
            iflyResultString = result;
          });
        }
      },
      onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
        setState(() {
          // iflyResultString += '\n$filePath';
        });
      }
    );
    XFVoice.shared.start(listener: listen);
  }

  _buttonTwo() {
    print('结束按键');
    XFVoice.shared.stop();
  }
}