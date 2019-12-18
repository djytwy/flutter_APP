import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonGroup extends StatefulWidget {
  ButtonGroup({
    Key key, 
    this.titleList,
    this.imageCallback,
    this.context2,
    this.clickFunc
  }):super(key:key);

  final List titleList;
  final imageCallback;
  final BuildContext context2;
  final clickFunc;

  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  Future _onImageButtonPressed(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    try {
      File compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 70, percentage: 30);
      if(compressedFile != null ) widget.imageCallback(compressedFile);
      Navigator.pop(context);
    } catch (e) {
      widget.imageCallback(image);
      print('-------图片压缩失败--------');
    }
  }

  @override
  void initState() {
    super.initState();
  }  

  @override
  Widget build(context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 20, 37)
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: ScreenUtil.getInstance().setHeight(92),
            padding: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(80)),
            color: Color.fromRGBO(0,20,37,1),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil.getInstance().setWidth(80),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text('上传图片', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(32))),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildList(),
          )
        ],
      ),
    );
  }

  Widget _btn(text) {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(32.0)),
      width: ScreenUtil.getInstance().setWidth(600.0),
      height: ScreenUtil.getInstance().setHeight(120.0),
      child: RaisedButton(
        color: Color.fromARGB(255, 113, 166, 241),
        onPressed: () {
          if(text == '相册') 
            _onImageButtonPressed(ImageSource.gallery);
          else if(text == '拍照')
            _onImageButtonPressed(ImageSource.camera);
          else
            widget.clickFunc();
        },
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  List<Widget> buildList() {
    List<Widget> tiles = [];
    for( var item in widget.titleList ) {
      tiles.add(_btn(item));
    }
    return tiles;
  }
}

Future compressImg(ImageSource source, Function imageCallback) async {
  File image = await ImagePicker.pickImage(source: source);
  try {
    File compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 100, percentage: 100);
    if(compressedFile != null ){
      await imageCallback('/appInfo/upload', image);
    }
  } catch (e) {
    await imageCallback('/appInfo/upload', image);
    print('-------图片压缩失败--------');
  }
}
