import 'package:flutter/material.dart';
import 'dart:async';
import 'package:xfvoice/xfvoice.dart';

class VoiceRecognize extends StatefulWidget {
  VoiceRecognize({
    Key key, 
    this.voiceCallback,
    this.startSpeech,
    this.endSpeech,
    this.adapt
  }):super(key:key);
  final ValueChanged<String> voiceCallback;  // 识别结果的回调
  final startSpeech;   // 开始说话的回调
  final endSpeech;    // 结束说话的回调
  final adapt;        // 自适应的实例
  
  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<VoiceRecognize> {
  String iflyResultString = '';
  String buttonText = '按下开始说话';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    
  }

  // Future askForPermissions() async {
  //   Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final voice = XFVoice.shared;
    voice.init(appIdIos: '5d6ced55', appIdAndroid: '5d6ced55');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    param.asr_ptt = '0';
    // 四川话的参数
    param.accent = 'lmz';
    param.asr_audio_path = 'xme.pcm';
    param.result_type = 'plain';
    voice.setParameter(param.toMap());
  }

  @override
  Widget build(BuildContext context) {
    final _adapt = widget.adapt;
    return GestureDetector(
      child: Container(
        width: _adapt.setWidth(345.0),
        height: _adapt.setHeight(50.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(_adapt.setWidth(90.0),0.0,_adapt.setWidth(10.0),0.0),
                child: Icon(Icons.wb_auto,color: Colors.white,),
              ),
              Expanded(
                child: Text(buttonText, style: TextStyle(color: Colors.white,fontSize: _adapt.setFontSize(18.0))),
              )
            ],
          )
        ),
      ),
      onTapDown: (d) {
        widget.startSpeech();
        setState(() {
          buttonText = '说话中....';
          iflyResultString = '';
        });
        _recongize();
      },
      onTapUp: (d) {
        setState(() {
          buttonText = '按下我开始说话';
        });
        _recongizeOver();
        widget.endSpeech();
      },
      onPanEnd: (DragEndDetails e){
        setState(() {
          buttonText = '按下我开始说话';
        });
        _recongizeOver();
        widget.endSpeech();
      },
    );
  }

  void _recongize() {
    widget.voiceCallback('');
    final listen = XFVoiceListener(
      onVolumeChanged: (volume) {
        print('$volume');
      },
      onResults: (String result, isLast) {
        if (result.length > 0) {
          print('这个是result： $result');
          setState(() {
            iflyResultString += result;
          });
        }
      },
      onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
        setState(() {
          
        });
      },

      onEndOfSpeech: (){

      } 
    );
    XFVoice.shared.start(listener: listen);
  }

  void _recongizeOver() {
    XFVoice.shared.stop();
    const delay1s = Duration(seconds: 1);
    Timer(delay1s, (){
      _voiceCallback();
    });
  }
  
  void _voiceCallback() {
    widget.voiceCallback('$iflyResultString');
  }
}