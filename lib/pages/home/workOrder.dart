import 'package:flutter/material.dart';

class WorkOrder extends StatefulWidget {
  WorkOrder({Key key}) : super(key: key);

  _WorkOrderState createState() => _WorkOrderState();
}

class _WorkOrderState extends State<WorkOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('工单', style: TextStyle(fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.transparent
      ),
      body: Center(
        child: Text('data')
      ),
    );
  }
}
