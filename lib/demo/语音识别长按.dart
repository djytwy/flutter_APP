import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:xfvoice/xfvoice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  String voiceMsg = '暂无数据';
  String iflyResultString = '按下方块说话';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

   Future<void> initPlatformState() async {
    final voice = XFVoice.shared;
    // 请替换成你的appid
    voice.init(appIdIos: '5d53632c', appIdAndroid: '5d53633c');
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
      title: '测试的demo',
      home: Scaffold(
        appBar: AppBar(
          title: new Text('测试demo'),
        ),
        body: Center(
          child: GestureDetector(
            child: Container(
              child: Text(iflyResultString),
              width: 300.0,
              height: 300.0,
              color: Colors.blueAccent,
            ),
            onTapDown: (d) {
              setState(() {
                voiceMsg = '按下';
              });
              _recongize();
            },
            onTapUp: (d) {
              _recongizeOver();
            },
          ),
        )
      ),
    );
  }

  void _recongize() {
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
          
        });
      }
    );
    XFVoice.shared.start(listener: listen);
  }

  void _recongizeOver() {
    XFVoice.shared.stop();
  }
}