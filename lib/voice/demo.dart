import 'package:flutter/material.dart';
import 'dart:async';
import 'package:xfvoice/xfvoice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key, this.voiceCallback}):super(key:key);
  final ValueChanged<String> voiceCallback;
  
  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<MyApp> {
  String iflyResultString = '';
  String buttonText = '按下开始说话';

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
      title: 'demo',
      home: Scaffold(
        appBar: AppBar(title: Text('xf_voice_demo')),
        body: GestureDetector(
          child: Container(
            width: 100.0,
            height: 100.0,
            color: Colors.blueAccent,
            child: Center(
              child: Text(buttonText),
            ),
          ),
          onTapDown: (d) {
            setState(() {
              buttonText = '说话中....';
            });
            _recongize();
          },
          onTapUp: (d) {
            setState(() {
              buttonText = '按下我开始说话';
            });
            _recongizeOver();
          },
        ),
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
          _voiceCallback();
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
  
  void _voiceCallback() {
    widget.voiceCallback('$iflyResultString');
  }
}