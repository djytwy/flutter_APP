import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import '../../../utils/util.dart';


class PrivateDatePrick extends StatefulWidget {
  PrivateDatePrick({
    Key key, this.change
    }) : super(key: key);
  Function change;
  _PrivateDatePrick createState() => _PrivateDatePrick();
}

class _PrivateDatePrick extends State<PrivateDatePrick> {
  String _format = 'yyyy';
  DateTime _dateTime; //默认日期
  String value;
  void _showDatePicker() {
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
        String month = item.month.toString();
        String day = item.day.toString();
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
            width: _adapt.setWidth(110),
            padding: EdgeInsets.only(right: _adapt.setWidth(15)),
            child: Container(
              child: DropdownButton(
                items: getListData(),
                hint:new Text( value == null ? '请选时间' : value,textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFff0000), fontSize: _adapt.setFontSize(13))),//当没有默认值的时候可以设置的提示
                // value: value,//下拉菜单选择完之后显示给用户的值
                onChanged: (val){//下拉菜单item点击之后的回调
                  setState(() {
                    _format = val;
                  });
                  this._showDatePicker();
                },
                elevation: 24,//设置阴影的高度
                style: new TextStyle(//设置文本框里面文字的样式
                  color: Colors.red
                ),
                // isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                iconSize: 20.0,
              )
            ),
          ),
    );
  }
}

List<DropdownMenuItem> getListData(){
  List<DropdownMenuItem> items=new List();
  DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
    child:new Text('按年筛选'),
    value: 'yyyy',
  );
  items.add(dropdownMenuItem1);
  DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
    child:new Text('按月筛选'),
    value: 'yyyy-MMMM',
  );
  items.add(dropdownMenuItem2);
  DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
    child:new Text('按天筛选'),
    value: 'yyyy-MMMM-dd',
  );
  items.add(dropdownMenuItem3);
  return items;
}