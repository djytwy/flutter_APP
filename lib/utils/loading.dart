import 'package:flutter/material.dart';
import './util.dart';

Set dict = Set();
bool loadingStatus = false;
class Loading {
  // static dynamic ctx;
  static void show(uri, {text = '加载中...'}) {
    if(CTX == null){
      return;
    }
    dict.add(uri); // 放入set变量中
    // 已有弹窗，则不再显示弹窗, dict.length >= 2 保证了有一个执行弹窗即可，
    if (loadingStatus == true || dict.length >= 2) {
      return ;
    }
    loadingStatus = true; // 修改状态
    // 请求前显示弹窗
    showDialog(
      context: CTX.currentState.overlay.context,
      barrierDismissible: false,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Container(
              child: new Center(
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  child: new Container(
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius:BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Text('加载中...', style: new TextStyle(fontSize: 12.0, color: Colors.black87)),
                        ),
                      ]
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }
    );
  }

  static Future cancel(uri) async {
    await Future.delayed(Duration(milliseconds: 100));
    if( CTX == null){
      return;
    }
    dict.remove(uri);
    // 所有接口接口返回并有弹窗
    if (dict.length == 0 && loadingStatus == true) {
      loadingStatus = false; // 修改状态
      // 完成后关闭loading窗口
      CTX.currentState.pop();
    }
  }
}