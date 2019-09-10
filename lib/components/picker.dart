import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/src/material/dialog.dart' as Dialog;
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustPicker extends StatefulWidget {
  CustPicker({Key key, 
    // this.width,
    this.itemsString, 
    this.scaffoldKey, 
    this.pickerCallback,
    this.textWidth,
    this.iconWidth,
    this.setData,
    this.flag=false,
    this.defaultGrade=false
  }) : super(key: key);
  double textWidth;
  double iconWidth;
  String itemsString;
  final pickerCallback;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final setData; // 设置的数据
  final flag;   // 控制标志
  final defaultGrade; // 工单优先级默认 中 
  
  @override
  _CustPickerState createState() => _CustPickerState();
}

class _CustPickerState extends State<CustPicker> {
  final double listSpec = 4.0;
  String stateText;
  String result = '请选择';

  @override
  void initState() {
    // TODO: implement initState
    if(widget.defaultGrade != false) {
      setState(() {
        result = '中';
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget (CustPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    String text = widget.setData;
    print('组件更新: $text');
    if(widget.flag && widget.setData != null) 
      setState(() {
        result = widget.setData;
      });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);  
    
    return Container(
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil.getInstance().setWidth(widget.textWidth),
              child: Text(result, style: TextStyle(color: Colors.white),textAlign: TextAlign.right,)
            ),
            Container(
              width: ScreenUtil.getInstance().setWidth(widget.iconWidth),
              child: Icon(Icons.keyboard_arrow_right, color: Colors.white),
            )
          ],
        ),
        onTap: (){
          showPicker(context);
        },
      ),
    );
  }

  void _pickerCallback(context, value) {
    widget.pickerCallback(context, value);
  }
  
  showPicker(BuildContext context) {
    Picker picker = Picker(
      adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(widget.itemsString)),
      changeToFirst: true,
      textAlign: TextAlign.left,
      textStyle: const TextStyle(color: Colors.blue),
      selectedTextStyle: TextStyle(color: Colors.red),
      columnPadding: const EdgeInsets.all(8.0),
      cancelText:'取消',
      confirmText: '确定',
      onConfirm: (Picker picker, List value) {
        // print(value.toString());                 // 选择的数组的位置
        // print(picker.getSelectedValues());       // 选择的数据
        result = '';
        for (var index in picker.getSelectedValues()) {
          result += index;
        }
        _pickerCallback(result, value);
        setState(() {
          result = result;
        });
      }
    );
    picker.show(widget.scaffoldKey.currentState);
  }

  showPickerModal(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(widget.itemsString)),
      changeToFirst: true,
      hideHeader: false,
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.adapter.text);
      }
    ).showModal(this.context); //widget.scaffoldKey.currentState);
  }

  showPickerIcons(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter(data: [
          PickerItem(text: Icon(Icons.add), value: Icons.add, children: [
            PickerItem(text: Icon(Icons.more)),
            PickerItem(text: Icon(Icons.aspect_ratio)),
            PickerItem(text: Icon(Icons.android)),
            PickerItem(text: Icon(Icons.menu)),
          ]),
          PickerItem(text: Icon(Icons.title), value: Icons.title, children: [
            PickerItem(text: Icon(Icons.more_vert)),
            PickerItem(text: Icon(Icons.ac_unit)),
            PickerItem(text: Icon(Icons.access_alarm)),
            PickerItem(text: Icon(Icons.account_balance)),
          ]),
          PickerItem(text: Icon(Icons.face), value: Icons.face, children: [
            PickerItem(text: Icon(Icons.add_circle_outline)),
            PickerItem(text: Icon(Icons.add_a_photo)),
            PickerItem(text: Icon(Icons.access_time)),
            PickerItem(text: Icon(Icons.adjust)),
          ]),
          PickerItem(text: Icon(Icons.linear_scale), value: Icons.linear_scale, children: [
            PickerItem(text: Icon(Icons.assistant_photo)),
            PickerItem(text: Icon(Icons.account_balance)),
            PickerItem(text: Icon(Icons.airline_seat_legroom_extra)),
            PickerItem(text: Icon(Icons.airport_shuttle)),
            PickerItem(text: Icon(Icons.settings_bluetooth)),
          ]),
          PickerItem(text: Icon(Icons.close), value: Icons.close),
        ]),
        title: Text("Select Icon"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        },
    ).show(widget.scaffoldKey.currentState);
  }

  showPickerDialog(BuildContext context) {
    Picker(
        // adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(PickerData)),
        hideHeader: true,
        title: new Text("Select Data"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }

  showPickerArray(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            // pickerdata: JsonDecoder().convert(PickerData2),
            isArray: true,
        ),
        hideHeader: true,
        selecteds: [3, 0, 2],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancel: FlatButton(onPressed: () {
          Navigator.pop(context);
        }, child: Icon(Icons.child_care)),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 999, postfix: Text("\$"), suffix: Icon(Icons.insert_emoticon)),
          NumberPickerColumn(begin: 200, end: 100, jump: -10),
        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }

  showPickerNumberFormatValue(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: 0,
              end: 999,
              onFormatValue: (v) {
                return v < 10 ? "0$v" : "$v";
              }
          ),
          NumberPickerColumn(begin: 100, end: 200),
        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }

  showPickerDate(BuildContext context) {
    Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(),
      title: Text("Select Data"),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List value) {
        print((picker.adapter as DateTimePickerAdapter).value);
      }
    ).showDialog(context);
  }

  showPickerDateCustom(BuildContext context) {
    new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
          customColumnType: [2,1,0,3,4],
        ),
        title: new Text("Select Data"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }
    ).showDialog(context);
  }

  showPickerDateTime(BuildContext context) {
    new Picker(
        adapter: new DateTimePickerAdapter(
          type: PickerDateTimeType.kYMD_AP_HM,
          isNumberMonth: true,
          //strAMPM: const["上午", "下午"],
          yearSuffix: "年",
          monthSuffix: "月",
          daySuffix: "日",
          minValue: DateTime.now(),
          // twoDigitYear: true,
        ),
        title: new Text("Select DateTime"),
        textAlign: TextAlign.right,
        selectedTextStyle: TextStyle(color: Colors.blue),
        delimiter: [
          PickerDelimiter(column: 5, child: Container(
            width: 16.0,
            alignment: Alignment.center,
            child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
            color: Colors.white,
          ))
        ],
        footer: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Text('Footer'),
        ),
        onConfirm: (Picker picker, List value) {
          print(picker.adapter.text);
        },
        onSelect: (Picker picker, int index, List<int> selecteds) {
          this.setState(() {
            stateText = picker.adapter.toString();
          });
        }
    ).show(widget.scaffoldKey.currentState);
  }

  showPickerDateRange(BuildContext context) {
    print("canceltext: ${PickerLocalizations.of(context).cancelText}");

    Picker ps = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }
    );

    Picker pe = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(type: PickerDateTimeType.kYMD),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }
    );

    List<Widget> actions = [
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text(PickerLocalizations.of(context).cancelText)),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm(ps, ps.selecteds);
            pe.onConfirm(pe, pe.selecteds);
          },
          child: new Text(PickerLocalizations.of(context).confirmText))
    ];

    Dialog.showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("Select Date Range"),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Begin:"),
                  ps.makePicker(),
                  Text("End:"),
                  pe.makePicker()
                ],
              ),
            ),
          );
        });
  }

  showPickerDateTime24(BuildContext context) {
    new Picker(
        adapter: new DateTimePickerAdapter(
            type: PickerDateTimeType.kMDYHM,
            isNumberMonth: true,
            yearSuffix: "年",
            monthSuffix: "月",
            daySuffix: "日"
        ),
        title: new Text("Select DateTime"),
        onConfirm: (Picker picker, List value) {
          print(picker.adapter.text);
        },
        onSelect: (Picker picker, int index, List<int> selecteds) {
          this.setState(() {
            stateText = picker.adapter.toString();
          });
        }
    ).show(widget.scaffoldKey.currentState);
  }
}