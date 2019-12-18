import '../../voice/xf_voice.dart';
import 'package:flutter/material.dart';
import '../../utils/util.dart';
import '../../services/pageHttpInterface/comWorkOrder.dart';

class VoicePage extends StatefulWidget {
  VoicePage({Key key}) : super(key: key);

  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {

  bool speeching = false;  // 是否在说话
  String speechResult = "您说的话会在这里显示";  // 语音识别的结果

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future _getVoiceRecognize(result) async {
    setState(() {
      speechResult = result == null ? "" : result;
    });
    if(result != null && result != "") {
      Map <String, dynamic> _recognizeResult = await postVoiceData(result);
      if (_recognizeResult == null) showTotast('您说话的顺序不对哦，请重新说话','center');
      else if(_recognizeResult["msg"] != "处理成功" || _recognizeResult.containsValue(null)) {
        showTotast('您说话的顺序不对哦，请重新说话','center');
      } else {
        Navigator.pop(context,_recognizeResult);
      }
      setState(() {
        speeching = false;
      });
    } else if (result == "") {
       // 返回“”的时候是按下按钮，设置文本为空
      setState(() {
        speechResult = "";
      });
    } else {
      setState(() {
        speeching = false;
      });
      showTotast('识别失败，可能是您说的太快了，再试试呢？','center');
    }
  }

  void _startRecognize(){
    setState(() {
      speeching = true;
    });
  }

  void _endRecognize(){
    setState(() {
      speeching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _adapt = SelfAdapt.init(context);
    return Container(
      child: Scaffold(
        // key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // 取消返回按钮
          leading: Builder(
            builder: (BuildContext context) {
              return Container();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,  // 取消appbar的颜色
        ),
        body:Column(
          children: <Widget>[
            // 提示的title和下面的文字信息为一个container
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: _adapt.setWidth(23)),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: _adapt.setHeight(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: _adapt.setWidth(10)),
                            child: Icon(Icons.business_center,color: Colors.yellow),
                          ),
                          Expanded(
                            child: Container(child: Text('提示', style: TextStyle(color: Colors.yellow[100],fontSize: _adapt.setFontSize(18))),),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: _adapt.setHeight(10)),
                      alignment: Alignment.centerLeft,
                      child: Text('语音报修说话的例子如下:',style: TextStyle(color: Colors.yellow[100],fontSize: _adapt.setFontSize(18))),
                    ),
                    Container(
                      child: Text("“厕所,问题：灯坏了,优先级高,不需要拍照”", style: TextStyle(color: Colors.white,fontSize: _adapt.setFontSize(18))),
                    )
                  ],
                ),
              )
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: _adapt.setWidth(375),
                    alignment: Alignment.centerLeft,
                    color: Color.fromARGB(255, 12, 25, 46),
                    child: FlatButton(
                      child: Text('返回', style: TextStyle(color: Colors.white30)),
                      onPressed: (){Navigator.pop(context);},
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: _adapt.setWidth(375),
                      color: Color.fromARGB(255, 10, 32, 60),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(_adapt.setWidth(23), _adapt.setHeight(15), 0.0, _adapt.setHeight(40)),
                            alignment: Alignment.centerLeft,
                            child: Text(speechResult, style:TextStyle(color: Colors.white,fontSize: _adapt.setFontSize(18))),
                          ),
                          Container(
                            child: speeching ? Image(image: AssetImage('assets/images/wave.gif'),width: _adapt.setWidth(180),height: _adapt.setHeight(100),)
                            : Image(image: AssetImage('assets/images/stop.png'),width: _adapt.setWidth(180),height: _adapt.setHeight(100)),
                          ), 
                          Container(
                            child: VoiceRecognize(
                              adapt: _adapt,
                              startSpeech: _startRecognize, 
                              endSpeech: _endRecognize,
                              voiceCallback: (r) => _getVoiceRecognize(r),
                            ),
                          )   
                        ],
                      ),
                    )
                  )
                ],
              ),
            )
          ],
        )
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        )
      )
    );
  }
}