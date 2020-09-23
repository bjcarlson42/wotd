import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var now = new DateTime.now().add(Duration(days: -1));
var formatter = new DateFormat.yMMMMd('en_US');
String today = formatter.format(now);

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              today,
              style: TextStyle(color: Colors.grey, fontSize: 13.0),
            ),
            Text(
              'Yesterday',
              style: TextStyle(
                fontSize: 33.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
