/**
 * 即时工单页的抽屉页
 * 参数：
 *  data:传入的页面的数据为一个树形结构的数据（例如：工单状态、优先级）
 * author: djytwy on 2019-11-11 16:58
 */
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 单选按钮
import 'drawPageButton.dart';
// 第二级的多选按钮
import 'drawPageSecond.dart';
// 工具类
import '../../../utils/util.dart';

class DrawPage extends StatefulWidget {
  DrawPage({
    Key key,
    this.data,
  }):super();
  final data;

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  // 操作的标志若返回false则不刷新页面
  bool optionFlag = false;
  // 当前选中的文案
  String checked = 'test1';
  // 当前菜单的二级选型类型是否单选：false：多选，true：单选
  bool single = false;
  // 右边的多选
  List detailData = [];
  // 选中值的list
  List checkedList = [];  // 默认选中第一级
  // 返回到即时工单页的数据
  Map genData = {};
  // 非质检人员看到的数据
  List uncheckPeople = [
    {
      'label': '工单状态',
      'name': 'state',
      'children': [
        {'label': '全部状态', 'children': [],'checked': false},
        {'label': '新建', 'children': [],'checked': false},
        {'label': '处理中', 'children': [],'checked': false},
        {'label': '已完成', 'children': [],'checked': false},
        {'label': '待验收', 'children': [],'checked': false},
        {'label': '退回中', 'children': [],'checked': false},
        {'label': '无法处理', 'children': [],'checked': false},
        {'label': '挂起', 'children': [],'checked': false}
      ],
      'checked': true
    },
    {
      'label': '优先级',
      'name': 'grade',
      'children': [
        {'label': '全部优先级', 'children': [],'checked': false},
        {'label': '高优先级', 'children': [],'checked': false},
        {'label': '中优先级', 'children': [],'checked': false},
        {'label': '低优先级', 'children': [],'checked': false}
      ],
      'checked': false
    },
    {
      'label': '验收超时',
      'name': 'delay',
      'children': [
        {'label': '全部', 'children': [],'checked': true},
        {'label': '是', 'children': [],'checked': false},
        {'label': '否', 'children': [],'checked': false}
      ],
      'single':true,
      'checked': false
    }
  ];
  // 质检人员看到的数据
  List checkPeople = [
    {
      'label': '工单状态',
      'name': 'state',
      'children': [
        {'label': '全部状态', 'children': [],'checked': false},
        {'label': '新建', 'children': [],'checked': false},
        {'label': '处理中', 'children': [],'checked': false},
        {'label': '已完成', 'children': [],'checked': false},
        {'label': '待验收', 'children': [],'checked': false},
        {'label': '退回中', 'children': [],'checked': false},
        {'label': '无法处理', 'children': [],'checked': false},
        {'label': '挂起', 'children': [],'checked': false}
      ],
      'checked': true
    },
    {
      'label': '优先级',
      'name': 'grade',
      'children': [
        {'label': '全部优先级', 'children': [],'checked': false},
        {'label': '高优先级', 'children': [],'checked': false},
        {'label': '中优先级', 'children': [],'checked': false},
        {'label': '低优先级', 'children': [],'checked': false}
      ],
      'checked': false
    },
    {
      'label': '验收超时',
      'name': 'delay',
      'children': [
        {'label': '全部', 'children': [],'checked': true},
        {'label': '是', 'children': [],'checked': false},
        {'label': '否', 'children': [],'checked': false}
      ],
      'single':true,
      'checked': false
    }
  ];
  // 页面显示的全部数据（第一级label默认显示）
  List pageData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllAuths().then((val) {
      if(val["check"])
        setState(() {
          pageData = checkPeople;
        });
      else
        setState(() {
          pageData = uncheckPeople;
        });
      // 默认点击第一个
      _clickFirst(pageData[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 672)..init(context);  // 以苹果6适配
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
            child: Text('搜索',style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(18)))
          ),
          actions: <Widget>[
            SizedBox(width: ScreenUtil.getInstance().setWidth(50))
          ],
        ),
        body: Row(
          children: <Widget>[
            // 第一个container作左边的容器放图片和阴影
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8.0
                  )
                ],
              ),
              child: Container(
                width: ScreenUtil.getInstance().setWidth(110),
                decoration: BoxDecoration(
                  color: Color(0x60000000)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: ListView.builder(
                        itemCount: pageData.length,
                        itemBuilder: (context,index) {
                          return DrawPageButton(
                            clickCb: _clickFirst,
                            item: pageData[index],
                            checked: pageData[index]["checked"],
                          );
                        }
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 11,  // 布局
                      child: ListView.builder(
                        itemCount: detailData.length,
                        itemBuilder: (context,index) {
                          return DrawPageSecond(
                            checked: detailData[index]["checked"],
                            clickCb: _multiPicker,
                            label: detailData[index]["label"],
                          );
                        }
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    color: Color.fromARGB(255, 28, 59, 101),
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text('重置',style: TextStyle(color: Colors.white70)),
                                    ),
                                  ),
                                  onTap: _reset,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    color: Color.fromARGB(255, 13, 166, 241),
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text('完成',style: TextStyle(color: Colors.white70)),
                                    ),
                                  ),
                                  onTap: _query,
                                )
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
  
  // 单选选中的值
  void _clickFirst(item) {
    setState(() {
      checked = item["label"];
      checkedList = [];
      single = item["single"]?? false;
      optionFlag = true;
    });
    _findLabel(pageData);
    if(single == true) {
      // 单选默认选全部
      _multiPicker("全部");
    }
  }
  
  // 多选选中的值
  void _multiPicker(checkItem) {
    // 临时赋值变量便于循环赋值
    dynamic temp = detailData;
    // 若选中list有全部则不能选下面的子项，若再次点击全部则取消选中
    if(checkedList.toString().contains("全部") && single != true) {
      if (checkItem.toString().contains('全部')) ;
      else {
        showTotast('您已经选了全部的数据,不需要再选取下面的数据');
        return;
      }
    } else if(checkItem.contains('全部') && single != true) {
      // dart 语法允许被循环对象的子项改变从而改变被循环对象
      for(Map _index in temp) _index["checked"] = false;
    }
    setState(() {
      detailData = [];
      checkedList = [];
      optionFlag = true;
    });
    // 选择的UI状态 是否单选
    if(single == true) {
      for(Map _index in temp) {
        if(_index["label"] == checkItem) {
          if (_index["checked"] == false) {
            _index["checked"] = true;
          } else {
            _index["checked"] = false;
          }
        } else {
          _index["checked"] = false;
        }
        setState(() {
          detailData.add(_index);
        });
      }
    } else {
      for(Map _index in temp) {
        if(_index["label"] == checkItem) {
          if (_index["checked"] == false) {
            _index["checked"] = true;
          } else {
            _index["checked"] = false;
          }
        }
        setState(() {
          detailData.add(_index);
        });
      }
    }
    // 返回多选中的值
    for(Map _item in detailData) {
      if (_item["checked"] == true)
        setState(() {
          checkedList.add(_item["label"]);
        });
    }
    var checkedItem;  // 用于查找当前选中的值，从而改变pageData
    for(Map _index in pageData) if(_index["label"] == checked) checkedItem = _index;
    /* 上面的一句用forEach会在debug状态报错，导致断开连接:Unimplemented clone for Kernel expression: IfElement
      所以先使用for循环的办法
    * */
    // pageData.forEach((e) => {if(e["label"] == checked) checkedItem = e});
    int _index = pageData.indexOf(checkedItem);
    setState(() {
      pageData[_index]["children"] = detailData;
    });
    _genData();
  }

  // 递归循环查找选中label
  void _findLabel(data) {
    for(Map _index in data) {
      if(_index["label"] == checked ) {
        _index["checked"] = true;
        setState(() {
          detailData = _index["children"];
        });
      } else if(_index["children"].length != 0) {
        _index["checked"] = false;
        _findLabel(_index["children"]);
      } else {
        // 若循环不到则不进行操作
      }
    }
  }

  // 进行筛选查询
  Future<void> _query() async {
    Navigator.of(context).pop(genData);
  }

  // 完成多选点击的时候生成被选中数据
  void _genData() {
    for(Map _index in pageData) {
      if(_index["label"] == checked)
        setState(() {
          genData[_index["name"]] = checkedList;
        });
    }
    setState(() {
      genData['optionFlag'] = optionFlag;
    });
  }

  // 重置
  void _reset() {
    _resetChecked(pageData,detailData);
  }

  // 递归取消选中值
  void _resetChecked(data,detail) {
    String _detailData = jsonEncode(detail).toString().replaceAll('true', 'false');
    String _pageData = jsonEncode(data).toString().replaceAll('true', 'false');
    setState(() {
      pageData = jsonDecode(_pageData);
      detailData = jsonDecode(_detailData);
      checkedList = [];
    });
  }
}

