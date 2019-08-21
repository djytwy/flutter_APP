import 'package:flutter/material.dart';

class PartPage1 extends StatelessWidget {
  final BuildContext pageContext;

  const PartPage1({Key key, this.pageContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text.rich(
          TextSpan(
              style: TextStyle(fontSize: 20.0),
              text: 'This is part',
              children: [
                TextSpan(
                  style: TextStyle(fontSize: 40.0, color: Colors.red),
                  text: ' 1',
                )
              ]),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('part/part2');
          },
          child: Text('To Part 2'),
        ),
      ],
    );
  }
}