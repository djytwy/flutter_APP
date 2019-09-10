import 'package:flutter/material.dart';
import '../pages/workOrder/inTimeWorkOrder.dart';
import '../utils/util.dart';

void ShowWorkOrder(BuildContext context, backHome) async {
  var _adapt = SelfAdapt.init(context);
  final size =MediaQuery.of(context).size;
  // 备用变量
  var k = 'test';
  await showDialog(
    context: context,
    builder: (BuildContext context){
      return Stack(
        children: <Widget>[
          Positioned(
            top: _adapt.setHeight(size.height / 2 +  60.0),
            child: SimpleDialog(
            backgroundColor: Colors.transparent,
              children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              k = '及时工单';
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => InTimeWorkOrder(taskType:"0")
                              ));
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: _adapt.setWidth(65),
                                  height: _adapt.setWidth(65),
                                  margin: EdgeInsets.only(bottom: _adapt.setHeight(12)),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/jishiGD.png'),
                                      fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  )
                                ),
                                Text('及时工单', style: TextStyle(color: white_color, fontSize: _adapt.setFontSize(14)))
                              ],
                            ),
                          )
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              k = '巡检工单';
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => InTimeWorkOrder(taskType:"1")
                              ));
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: _adapt.setWidth(65),
                                  height: _adapt.setWidth(65),
                                  margin: EdgeInsets.only(bottom: _adapt.setHeight(12)),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/xunjianGD.png'),
                                      fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  )
                                ),
                                Text('巡检工单', style: TextStyle(color: white_color, fontSize: _adapt.setFontSize(14)))
                              ],
                            ),
                          )
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              k = '维保工单';
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => InTimeWorkOrder(taskType:"2")
                              ));
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: _adapt.setWidth(65),
                                  height: _adapt.setWidth(65),
                                  margin: EdgeInsets.only(bottom: _adapt.setHeight(12)),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/weibaoGD.png'),
                                      fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  )
                                ),
                                Text('维保工单', style: TextStyle(color: white_color, fontSize: _adapt.setFontSize(14)))
                              ],
                            ),
                          )
                        )
                      ],
                    )
                  )
              ]
            ),
          )
        ],
      );
    }
  ).then((val) {
    print(k);
    backHome();
  });
}
     