import 'package:flutter/material.dart';
class StackPosition extends StatefulWidget {
  StackPosition({Key key}) : super(key: key);

  _StackPositionState createState() => _StackPositionState();
}

class _StackPositionState extends State<StackPosition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
        onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context){
                return SimpleDialog(
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only(right: 28.0),
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
                                new Text('即时工单')
                              ],
                            )
                          ),
                          new Container(
                            margin: new EdgeInsets.only(right: 28.0),
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
                                new Text('即时工单')
                              ],
                            )
                          ),
                          new Container(
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
                                new Text('即时工单')
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                  contentPadding: EdgeInsets.all(0),
                );
              }
            );
          
          },
          child: Text("点击显示SimpleDialog"),
      ),
    );
  }
}