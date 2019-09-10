import 'package:flutter/material.dart';
import '../../../utils/util.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class SchedulingDatePrick extends StatefulWidget {
  SchedulingDatePrick({Key key, this.change}) : super(key: key);
  Function change;
  _SchedulingDatePrickState createState() => _SchedulingDatePrickState();
}

class _SchedulingDatePrickState extends State<SchedulingDatePrick> {
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime; //默认日期
  String value;
  @override
  void initState(){
    super.initState();
    setState(() {
      value = getCurrentDay();
    });
  }
  // 打开日期弹出框
  void _showDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('确认', style: TextStyle(color: Colors.red)),
        cancel: Text('取消', style: TextStyle(color: Colors.cyan)),
      ),
      // minDateTime: DateTime.parse('2015-1-1'),
      // maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: DateTimePickerLocale.zh_cn,
      // onClose: () => print("----- onClose -----"),
      // onCancel: () => print('onCancel'),
      // onChange: (dateTime, List<int> index) {
      // },
      onConfirm: (dateTime, List<int> index) {
        DateTime item = DateTime.parse(dateTime.toString());
        String str = '';
        String year = item.year.toString();
        String month = item.month >= 10 ? item.month.toString() : '0'+item.month.toString();
        String day = item.day >= 10 ? item.day.toString() : '0'+item.day.toString();
        if (_format == 'yyyy') {
          str = year;
        }else if (_format == 'yyyy-MMMM') {
          str = '$year-$month';
        }else if (_format == 'yyyy-MMMM-dd') {
          str = '$year-$month-$day';
        }
        setState(() {
          _dateTime = dateTime;
          value = str;
        });
        if (widget.change != null) {
            widget.change(str);
        }
      },
    );
  }
  // 上一个
  void prev(){
    if (value == null) {
      return;
    }
    this.dataProcess('-');
  }
  // 下一个
  void next(){
    if (value == null) {
      return;
    }
    this.dataProcess('+');
  }
  // 处理上下翻页的数据处理
  void dataProcess(String type){
    String dateString;
    if (_format == 'yyyy') { //年
      int year = int.parse(value);
      if (type == '-'){ 
        year -= 1;
      }else if (type == '+') {
        year += 1;
      }
      dateString = year.toString();
    }else if (_format == 'yyyy-MMMM'){
      var item = value.split('-');
      int year = int.parse(item[0]);
      int month = int.parse(item[1]);
      if (type == '-'){ 
        month -= 1;
        if (month < 1) {
          year -= 1;
          month = 12;
        }
      }else if (type == '+') {
        month += 1;
        if (month > 12) {
          year += 1;
          month = 1;
        }
      }
      String y = year.toString();
      String m = month >= 10 ? month.toString() : '0'+month.toString();
      dateString = '$y-$m';
    }else if (_format == 'yyyy-MMMM-dd') {
      var item = value.split('-');
      DateTime now = new DateTime(int.parse(item[0]), int.parse(item[1]), int.parse(item[2]));
      if (type == '-') {
        now =  now.add(Duration(days: -1));
      }else if (type == '+') {
        now =  now.add(Duration(days: 1));
      }
      String y = now.year.toString();
      String m = now.month >= 10 ? now.month.toString() : '0'+now.month.toString();
      String d = now.day >= 10 ? now.day.toString() : '0'+now.day.toString();
      dateString = '$y-$m-$d';
    }
    setState(() {
      value = dateString;
    });
    if (widget.change != null) {
      widget.change(dateString);
    }
  }
  @override
  Widget build(BuildContext context) {
    var _adapt = SelfAdapt.init(context);
    return Container(
            margin: EdgeInsets.only(top: _adapt.setHeight(10)),
            padding: EdgeInsets.fromLTRB(_adapt.setWidth(30), 0, _adapt.setWidth(30), 0),
            height: _adapt.setHeight(42),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(91, 156, 192, 0.3), Color.fromRGBO(0, 117, 141, 0.3)],
              ),
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: this.prev,
                  icon: Icon(Icons.arrow_left, color: Color.fromRGBO(67, 154, 255, 1), size: _adapt.setFontSize(35))
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: PopupMenuButton(
                        child: Text( value != null ? value : '', style: TextStyle(color: Color.fromRGBO(67, 154, 255, 1), fontSize: _adapt.setFontSize(24))),
                        onSelected: (String value){
                          setState(() {
                            _format = value;
                          });
                          _showDatePicker(context);
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuItem<String>>[
                            PopupMenuItem<String>(child: Text("按年筛选"), value: "yyyy",),
                            PopupMenuItem<String>(child: Text("按月筛选"), value: "yyyy-MMMM",),
                            PopupMenuItem<String>(child: Text("按天筛选"), value: "yyyy-MMMM-dd",),
                          ];
                        },
                        offset: Offset.zero
                      )
                    )
                ),
                IconButton(
                  onPressed: this.next,
                  icon: Icon(Icons.arrow_right, color:Color.fromRGBO(67, 154, 255, 1), size: _adapt.setFontSize(35))
                ),
              ],
            ),
          );
  }
}