import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import '../../../utils/util.dart';


class PrivateDatePrick extends StatefulWidget {
  PrivateDatePrick({
    Key key, this.change, this.defaultDateString
    }) : super(key: key);
  Function change;
  String defaultDateString;
  _PrivateDatePrick createState() => _PrivateDatePrick();
}

class _PrivateDatePrick extends State<PrivateDatePrick> {
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime; //默认日期
  String value;
  @override initState(){
    super.initState();
    setState(() {
      value = widget.defaultDateString != null ? widget.defaultDateString : getCurrentTime(timeParams: 2);
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
  @override
  Widget build(BuildContext context) {
    var _adapt =  SelfAdapt.init(context);
    return Container(
       child: Container(
            width: _adapt.setWidth(100),
            // color: Colors.red,
            padding: EdgeInsets.only(right: _adapt.setWidth(15)),
            alignment: Alignment.centerRight,
            child: PopupMenuButton(
              child: Container(
                alignment: Alignment.center,
                height: _adapt.setHeight(25),
                padding: EdgeInsets.fromLTRB(_adapt.setWidth(5), 0, _adapt.setWidth(5), 0),
                child: Text(value, style: TextStyle(fontSize: _adapt.setFontSize(12))),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(76,183,255,0.43),
                  border: Border.all(width: _adapt.setWidth(1),color: Color.fromRGBO(99,198,255,1)),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
              ),
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
              // offset: Offset.zero
            )
            // Expanded(
            //       child: Container(
            //         alignment: Alignment.center,
            //         child: PopupMenuButton(
            //             child: Text( value != null ? value : '', style: TextStyle(color: Color.fromRGBO(67, 154, 255, 1), fontSize: _adapt.setFontSize(24))),
            //             onSelected: (String value){
            //               setState(() {
            //                 _format = value;
            //               });
            //               _showDatePicker(context);
            //             },
            //             itemBuilder: (BuildContext context) {
            //               return <PopupMenuItem<String>>[
            //                 PopupMenuItem<String>(child: Text("按年筛选"), value: "yyyy",),
            //                 PopupMenuItem<String>(child: Text("按月筛选"), value: "yyyy-MMMM",),
            //                 PopupMenuItem<String>(child: Text("按天筛选"), value: "yyyy-MMMM-dd",),
            //               ];
            //             },
            //             offset: Offset.zero
            //           )
            //         )
            //     )
            //  Container(
            //   child: DropdownButton(
            //     items: getListData(),
            //     hint:new Text( value == null ? '请选时间' : value,textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFff0000), fontSize: _adapt.setFontSize(13))),//当没有默认值的时候可以设置的提示
            //     // value: value,//下拉菜单选择完之后显示给用户的值
            //     onChanged: (val){//下拉菜单item点击之后的回调
            //       setState(() {
            //         _format = val;
            //       });
            //       this._showDatePicker();
            //     },
            //     elevation: 24,//设置阴影的高度
            //     style: new TextStyle(//设置文本框里面文字的样式
            //       color: Colors.red
            //     ),
            //     // isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
            //     iconSize: 20.0,
            //   )
            // ),
          ),
    );
  }
}