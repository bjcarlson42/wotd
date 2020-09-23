import 'package:flutter/material.dart';
import 'package:wotd/components/nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Of The Day',
      theme: ThemeData(
        primaryColor: Color(0xffffffff),
      ),
      debugShowCheckedModeBanner: false,
      home: Nav(),
    );
  }
}
