import 'package:flutter/material.dart';
import 'package:wotd/screens/home_screen/components/main.dart';
import 'package:wotd/screens/home_screen/components/top_section.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          TopSection(),
          Main(),
        ],
      ),
    );
  }
}