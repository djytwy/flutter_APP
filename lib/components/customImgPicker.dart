/**
 * 图片选择的组件
 * author: djytwy on 2019-11-07 14:47
 *  imageCallback：回调函数
 *  context：传入的上下文
 */
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/util.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import '../services/pageHttpInterface/reportFix.dart';

class CustomImgPicker extends StatelessWidget {
  CustomImgPicker({
    Key key,
    this.imageCallback,
    this.context,
  }):super(key:key);
  BuildContext context;
  final imageCallback;

  @override
  Widget build(BuildContext context) {
    SelfAdapt _adpt = SelfAdapt.init(context);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 20, 37)
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: _adpt.setHeight(46),
            padding: EdgeInsets.only(right: _adpt.setWidth(40)),
            color: Color.fromRGBO(0,20,37,1),
            child: Row(
              children: <Widget>[
                Container(
                  width: _adpt.setWidth(40),
                  alignment: Alignment.topCenter,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text('上传图片', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _adpt.setFontSize(16))),
                )
              ],
            ),
          ),
          //相册选取照片
          _btn('相册'),
          SizedBox(height: _adpt.setHeight(16.0)),
          _btn('拍照')
        ],
      ),
    );
  }

  Widget _btn(text) {
    SelfAdapt _adpt = SelfAdapt.init(context);
    return Container(
      width: _adpt.setWidth(300.0),
      height: _adpt.setHeight(45.0),
      child: RaisedButton(
        color: Color.fromARGB(255, 113, 166, 241),
        onPressed: (){
          text == '相册' ? _onImageButtonPressed(ImageSource.gallery) :
          _onImageButtonPressed(ImageSource.camera);
        },
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future _onImageButtonPressed(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    dynamic url;
    try {
      File compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 70, percentage: 30);
      url = await uploadImg(compressedFile);
      if(compressedFile != null ){
        this.imageCallback(compressedFile, url);
      }
      Navigator.pop(context);
    } catch (e) {
      this.imageCallback(image,url);
      print('-------图片压缩失败--------');
    }
  }
}
