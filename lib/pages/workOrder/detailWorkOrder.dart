import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/listItem.dart';
import '../../components/textLabel.dart';

class DetailWordOrder extends StatefulWidget {
  DetailWordOrder({
    Key key, 
    this.orderID
  }) : super(key: key);
  final orderID;

  _DetailWordOrderState createState() => _DetailWordOrderState();
}

class _DetailWordOrderState extends State<DetailWordOrder> {

  String place = '都江堰K23';
  String time = '2019-06-09 13:56';
  String people = '唐三(工程部)';
  String grade = '高优先级';
  String content = '较为哦豁覅二狗我合格后南方卡瓦尼氛围就我跟我价位高我我今晚一骨灰盒监管科热计量高科技或过热海贵人';
  String complete = '5天';
  int orderID;

  @override
  void initState() {
    // TODO: implement initState
    orderID = widget.orderID;
    super.initState();
  }

  List<Widget> Boxs(length) => List.generate(length, (index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      width: ScreenUtil.getInstance().setWidth(360),
      height: ScreenUtil.getInstance().setHeight(270),
      alignment: Alignment.center,
      child: Image.network('https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png'),
    );
  }); 

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
     double fontSize = ScreenUtil.getInstance().setSp(30);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        appBar: AppBar(
          backgroundColor: Colors.transparent, 
          title: Center(
            child: Text('工单详情',style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)))
          ),
          actions: <Widget>[          // 占位，保持居中
            Container(
              width: ScreenUtil.getInstance().setWidth(120),
              child: Text('')
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(16)),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: TextLable(
                            broderColor: Color.fromARGB(255, 239, 111, 111), 
                            text: '优先级高', 
                            bgcolor: Color.fromARGB(120, 82, 52, 56)
                          ),
                        ),
                        Expanded(
                          child: TextLable(
                            align: 'right',
                            broderColor: Color.fromARGB(255, 142, 245, 108), 
                            text: '已完成', 
                            bgcolor: Color.fromARGB(255, 42, 83, 57)
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 100.0,
                      child: Text('进度条占位', style: TextStyle(color: Colors.white)),
                    ),
                    ListItem(title: '报修人', content: place, border: true, phone: false, phoneNum: '10086',),
                    ListItem(title: '抄送人', content: time,border: true),
                    ListItem(title: '处理岗位', content: people,border: true,),
                    ListItem(title: '处理人', content: grade, phone: false, phoneNum: '10086'),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        0.0,
                        ScreenUtil.getInstance().setHeight(22),
                        0.0,
                        ScreenUtil.getInstance().setHeight(22),
                      ),
                      color: Color.fromARGB(100, 12, 33, 53),
                      height: ScreenUtil.getInstance().setHeight(220),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(30)),
                            alignment: Alignment.centerLeft,
                            child: Text('内容',style: TextStyle(fontSize: fontSize,color: Colors.white70)),
                          ),
                          Container(
                            width: ScreenUtil.getInstance().setWidth(690),
                            child: Text('$content', maxLines: 5,style: TextStyle(fontSize: fontSize,color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    ListItem(title: '完成时限', content: '5天',color: Colors.greenAccent),
                    Container(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: Boxs(4),
                      ),
                      margin: EdgeInsets.fromLTRB(
                        0.0, 
                        ScreenUtil.getInstance().setHeight(20), 
                        0.0, 
                        ScreenUtil.getInstance().setHeight(20)
                      ),
                    ), 
                    ListItem(title: '工单编号：$orderID', content: "",),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}