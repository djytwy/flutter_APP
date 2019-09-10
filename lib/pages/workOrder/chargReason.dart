// 退单原因
import 'package:flutter/material.dart';
import '../../utils/util.dart';
import 'package:app_tims_hotel/services/pageHttpInterface/workOrderContent.dart';
//组件
import '../../components/ButtonsComponents.dart';
import '../../components/NoteEntry.dart';


class ChargReason extends StatefulWidget {
  ChargReason({Key key, this.orderID}) : super(key: key);
  final orderID;
  _ChargReasonState createState() => _ChargReasonState();
}

class _ChargReasonState extends State<ChargReason> {
  int userId; //用户id
  String description;
  @override void initState() {
    super.initState();
    getLocalStorage('userId').then((val) {
      userId = int.parse(val);
    });
  }
  // 提交
  void _returnOrder(){
      if(description == null){
        showTotast('请填写退单原因！');
        return;
      }
       var data= {
        "id": widget.orderID,
        "now_userId": userId, 
        "optionType": 3, // 3代表申请退单
        "info": description
      };
      returnBack(data).then((val) {
        showTotast('操作成功！');
        Navigator.pop(context, true);
      });
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    return Container(
       decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        )
      ),
       child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('退单原因',style: TextStyle(fontSize: _adapt.setFontSize(18))),
                centerTitle: true,
                backgroundColor: Colors.transparent
              ),
              body:  Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //居左
                            children: <Widget>[
                               NoteEntry(title:'退单原因', change: (value){
                                  setState(() {
                                    description = value;
                                  });
                              })
                          ]
                        ),
                    ),
                  ),
                  ButtonsComponents(leftName: '确定', cbackLeft: _returnOrder, rightShow: false)
                ],
              )
          ),
    );
  }
}