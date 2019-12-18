import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/util.dart';
import 'package:dio/dio.dart';
import '../../config/serviceUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pageHttpInterface/uploadBarcode.dart';
import '../../components/buttonGroup.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/mobtest.dart'; // mob推送的测试

class BarcodeScan extends StatefulWidget {
  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  SelfAdapt _adapt;
  String barcode = "暂无结果";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _adapt = SelfAdapt.init(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(_adapt.setHeight(16.0)),
                child: _text("您还未进行手机绑定，请先绑定手机"),
              ),
              Container(
                width: _adapt.setWidth(300),
                height: _adapt.setHeight(45),
                margin: EdgeInsets.only(bottom: _adapt.setHeight(30)),
                child: FlatButton(
                  color: Color.fromARGB(255,113, 166, 241),
                  onPressed: scan, child: _text('点击开始扫码绑定')
                ),
              ),
               // 从相册读二维码
              loadImg('从相册读取二维码', _adapt, uploadFromPhone),
              // 测试消息推送
              // btn()
            ],
          ),
        )
      ),
    );
  }

  Widget loadImg(String text, SelfAdapt adpt, Function imageCallback) {
    return Container(
      width: adpt.setWidth(300.0),
      height: adpt.setHeight(45.0),
      child: RaisedButton(
        color: Color.fromARGB(255, 113, 166, 241),
        child: Text(text, style: TextStyle(color: Colors.white)),
        onPressed: (){
          compressImg(ImageSource.gallery, imageCallback);
        }
      ),
    );
  }

  Future uploadFromPhone(String url ,File imgfile) async {
     String _url = await uploadBarcode(url, imgfile);
     setState(() => this.barcode = _url);
     await _dialog();
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      await _dialog();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showTotast('检测相机未取得权限，请授权相机权限！');
      } else {
        showTotast('未知错误: $e');
      }
    } on FormatException{
      showTotast('未扫描到任何结果！');
    } catch (e) {
      showTotast('未知错误: $e');
    }
  }

  Future _dialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('扫描结果',textAlign: TextAlign.center),
          children: <Widget>[
            SimpleDialogOption(
              child: barcode == '暂无结果' || barcode == null ? Text('识别失败，请再尝试一下~'): Text('识别成功！点击到登录页'),
            ),
            SimpleDialogOption(
              child: Container(
                width: _adapt.setWidth(300.0),
                height: _adapt.setHeight(25),
                child: FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('确定', style: TextStyle(color: Colors.lightBlue)),
                )
              ),
            )
          ],
        );
      }
    ).then((val) async {
      print('扫描结果：$barcode');
      Dio dio = Dio();
      Map<String, dynamic> result;
      if (barcode != '暂无结果' && barcode != null) {
        Response response = await dio.get(barcode);
        if (response.statusCode == 200) {
          result = response.data;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('project', result["datas"]["projectUrl"].contains('https') ?
            result["datas"]["projectUrl"] :
            "https://${result["datas"]["projectUrl"]}"
          );
          prefs.setString('projectName', result["datas"]["projectName"] ?? null);
          if (result["code"] == 2000) {
            releaseUrl = result["datas"]["projectUrl"].contains('https') ?
              result["datas"]["projectUrl"] :
              "https://${result["datas"]["projectUrl"]}";
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          showTotast('服务器出错了！');
        }
      }
    });
  }

  // 本页的文字样式
  Widget _text(str) {
    return Container(
      child: Text(str,style: TextStyle(color: Colors.white,fontSize: _adapt.setFontSize(16))),
    );
  }
}
