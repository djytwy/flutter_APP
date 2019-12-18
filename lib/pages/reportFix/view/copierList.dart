import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CopierList extends StatelessWidget {
  CopierList({Key key, this.pageCback, this.data, this.delCopier}) : super(key: key);
  Function pageCback;
  Function delCopier;
  List data;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);  // 以苹果6适配
    return Expanded(
      flex: 3,
      child: FlatButton(
        onPressed: this.pageCback,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Wrap(
                alignment: data.length > 2 ? WrapAlignment.start :WrapAlignment.end,
                children: data.map((item){
                    if (item['isNoDel'] != null) {
                      return Container(
                        margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(5)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, ScreenUtil.getInstance().setHeight(5), ScreenUtil.getInstance().setWidth(20), 0),
                          child: Wrap(
                            children: <Widget>[
                              Text(item['userName'], style: TextStyle(color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(24))),
                              Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Container(
                                      width: ScreenUtil.getInstance().setWidth(30),
                                      height: ScreenUtil.getInstance().setWidth(30),
                                      child: Icon(Icons.lock,color: Colors.white, size: ScreenUtil.getInstance().setSp(20)),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(113, 166, 241, 1),
                                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().setWidth(15)))
                                      ),
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }else{
                      return Container(
                        margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(5)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, ScreenUtil.getInstance().setHeight(5), ScreenUtil.getInstance().setWidth(20), 0),
                          child: Wrap(
                            children: <Widget>[
                              Text(item['userName'], style: TextStyle(color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(24))),
                              Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Container(
                                      width: ScreenUtil.getInstance().setWidth(40),
                                      height: ScreenUtil.getInstance().setWidth(40),
                                      child: GestureDetector(
                                        onTap: (){
                                          delCopier(item);
                                        },
                                        child: Icon(Icons.close,color: Colors.white, size: ScreenUtil.getInstance().setSp(30)),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().setWidth(25)))
                                      ),
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                }).toList()
              )
            ),
            Icon(Icons.keyboard_arrow_right, color: Colors.white)
          ],
        )
      )
    );
  }
}