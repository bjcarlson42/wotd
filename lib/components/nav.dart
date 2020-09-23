import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wotd/components/drawer.dart';
import 'package:wotd/screens/home_screen/home_screen.dart';
import 'package:wotd/screens/past_words/past_words.dart';
import 'package:wotd/models/saved_words.dart';

class Nav extends StatefulWidget {
  static final _savedWords = SavedWords.savedWords;
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    PastWords(),
  ];
  var _savedWords = Nav._savedWords;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openFavorteWords() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Favorite Words'),
              elevation: 0.0,
            ),
            body: Container(
              child: _savedWords.length != 0
                  ? ListView(
                      children: _savedWords
                          .map(
                            (word) => Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                              child: Text(
                                '${word[0].toUpperCase()}${word.substring(1)}',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No favorite words! Click the heart on a word card to add some!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
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
            onPressed: _openFavorteWords,
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
