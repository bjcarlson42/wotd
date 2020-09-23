import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wotd/components/drawer.dart';
import 'package:wotd/screens/home_screen/home_screen.dart';
import 'package:wotd/screens/past_words/past_words.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    PastWords(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDarawer(),
      appBar: AppBar(
        title: Text('Word Of The Day'),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
            ),
            onPressed: () => {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            title: Text('WOTD'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.calendarWeek,
            ),
            title: Text('Past Words'),
          ),
        ],
        selectedItemColor: Colors.white,
        selectedFontSize: 16.0,
        unselectedItemColor: Colors.white,
        unselectedFontSize: 12.0,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
