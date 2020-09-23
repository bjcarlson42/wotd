import 'package:flutter/material.dart';
import 'package:wotd/screens/past_words/components/top_section.dart';
import 'package:wotd/screens/past_words/components/main.dart';

class PastWords extends StatelessWidget {
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
