/**
 * 重修原因页面
 * 参数：
 *  
 * author: djytwy on 2019-11-14 11:50
 */

//import 'package:flutter/material.dart';
//import '../../../utils/util.dart';
//
//
//class RepairReason extends StatefulWidget {
//  @override
//  _RepairReasonState createState() => _RepairReasonState();
//}
//
//class _RepairReasonState extends State<RepairReason> {
//  String _text;
//  @override
//  Widget build(BuildContext context) {
//    final _adapt =  SelfAdapt.init(context);
//    return Container(
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          fit: BoxFit.cover,
//          image: AssetImage('assets/images/background.png')
//        )
//      ),
//      child: Scaffold(
//        backgroundColor: Colors.transparent,
//        appBar: AppBar(
//          backgroundColor: Colors.transparent,
//          title: Center(child: Text('原因',style: TextStyle(fontSize: _adapt.setFontSize(18)))),
//          actions: <Widget>[
//            SizedBox(width: _adapt.setWidth(60),)
//          ],
//        ),
//        body: Container(
//          child: Column(
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(10.0),
//                child: TextField(
//                  maxLines: 10,
//                  decoration: InputDecoration(
//                    fillColor: Color(0x60000000),
//                    hintText:'请输入原因',
//                    hintStyle: TextStyle(
//                      color: Colors.white70
//                    ),
//                    border: InputBorder.none
//                  ),
//                  onChanged: _getText,
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  void _getText(v) {
//    setState(() {
//      _text = v;
//    });
//  }
//}


// 退单原因
import 'package:flutter/material.dart';
import '../../../utils/util.dart';
import 'package:app_tims_hotel/services/pageHttpInterface/workOrderContent.dart';
//组件
import '../../../components/ButtonsComponents.dart';
import '../../../components/NoteEntry.dart';
import '../../home/myTask.dart';
import '../../../utils/eventBus.dart';


class RepairReason extends StatefulWidget {
  RepairReason({
    Key key,
    this.orderID,
    this.optionType,
  }) : super(key: key);
  final orderID;
  final optionType;

  _RepairReasonState createState() => _RepairReasonState();
}

class _RepairReasonState extends State<RepairReason> {
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
      showTotast('请填写原因！');
      return;
    }
    var data= {
      "id": widget.orderID,
      "now_userId": userId,
      "optionType": widget.optionType, // 7代表重修 8代表无法处理 9代表挂起
      "info": description
    };
    returnBack(data).then((val) {
      bus.emit('refreshTask');
      showTotast('操作成功！');
      // pop两次到我的工单页面
      if(widget.optionType == 7 || widget.optionType == 8 || widget.optionType == 9) {
        print('跳转回去这个地方的处理方式有问题，但赶时间想不到合适的解决办法');
        // 如果是退单、挂起和无法处理需要pop四次
        Navigator.pop(context, true);
        Navigator.pop(context, true);
        Navigator.pop(context, true);
//        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
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
          title: Text('原因',style: TextStyle(fontSize: _adapt.setFontSize(18))),
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
                    NoteEntry(title:'原因', change: (value){
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