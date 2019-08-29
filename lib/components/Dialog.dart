import 'package:flutter/material.dart';
import '../pages/workOrder/inTimeWorkOrder.dart';

void ShowWorkOrder(BuildContext context, backHome) async {
  // 备用变量
  var k = 'test';
  await showDialog(
    context: context,
    builder: (BuildContext context){
      return SimpleDialog(
        children: <Widget>[
          ListTile(
            title: Row(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.only(right: 28.0),
                  child: GestureDetector(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          child: new Padding(
                            padding: new EdgeInsets.all(16.0),
                            child: new Icon(Icons.people),
                          ),
                          decoration: new BoxDecoration(
                            border: new Border.all(width: 2.0, color: Colors.red),
                            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                          ),
                        ),
                        new Text('及时工单')
                      ],
                    ),
                    onTap: (){
                      k = '及时工单';
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => InTimeWorkOrder(taskType:"0")
                      ));
                    },
                  ),
                ),
                new Container(
                  child: GestureDetector(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          child: new Padding(
                            padding: new EdgeInsets.all(16.0),
                            child: new Icon(Icons.people),
                          ),
                          decoration: new BoxDecoration(
                            border: new Border.all(width: 2.0, color: Colors.red),
                            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                          ),
                        ),
                        new Text('巡检工单')
                      ],
                    ),
                    onTap: (){
                      k = '巡检工单';
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => InTimeWorkOrder(taskType:"1")
                      ));
                    },
                  ),
                  margin: new EdgeInsets.only(right: 28.0),
                ),
                new Container(
                  child: GestureDetector(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          child: new Padding(
                            padding: new EdgeInsets.all(16.0),
                            child: new Icon(Icons.people),
                          ),
                          decoration: new BoxDecoration(
                            border: new Border.all(width: 2.0, color: Colors.red),
                            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                          ),
                        ),
                        new Text('维保工单')
                      ],
                    ),
                    onTap: (){
                      k = '维保工单';
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => InTimeWorkOrder(taskType:"2")
                      ));
                    },
                  )
                ),
              ],
            ),
          ),
        ],
        contentPadding: EdgeInsets.all(0),
      );
    }
  ).then((val) {
    print(k);
    backHome();
  });
}
     