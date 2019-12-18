/**
 * 预览图片的组件
 * 参数：
 *  imgFile: 图片的文件信息
 *  index: 图片的序号
 *  previewCallBack：回调函数(主要用于点击X的时候)
 * author: djytwy on 2019-11-07 16:49
 */
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 预览图片的组件
class Preview extends StatelessWidget {
  Preview({
    Key key,
    this.imgFile,
    this.index,
    this.previewCallBack
  }) : super(key: key);

  final File imgFile;   // 图片
  final int index;  // 该图片对应在数组的ID
  final previewCallBack; // 点击×的回调函数

  @override
  Widget build(BuildContext context) {
    // 判断一次是否为null避免报错
    return imgFile != null ? Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 5.0,
            width: ScreenUtil.getInstance().setWidth(88),
            height: ScreenUtil.getInstance().setHeight(88),
            child: Image.file(imgFile)
          ),
          Positioned(
            left: 18.0,
            top: -18.0,
            child: IconButton(
              iconSize: ScreenUtil.getInstance().setHeight(35),
              color: Colors.red,
              icon: Icon(Icons.close),
              onPressed: (){
                _previewCallBack(index);
              },
            ),
          ),
        ],
      ),
      height: ScreenUtil.getInstance().setHeight(110),
      width: ScreenUtil.getInstance().setWidth(105),
    ) : Text('');
  }

  void _previewCallBack(index){
    previewCallBack(index);
  }
}