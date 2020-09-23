import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wotd/key.dart';
import 'package:wotd/models/definition.dart';
import 'dart:convert';
import 'package:wotd/models/word.dart';
import 'package:wotd/models/saved_words.dart';

var now = new DateTime.now();
var formatter = new DateFormat('yyyy-MM-dd');
String one = formatter.format(now.add(Duration(days: -1)));
String two = formatter.format(now.add(Duration(days: -2)));
String three = formatter.format(now.add(Duration(days: -3)));
String four = formatter.format(now.add(Duration(days: -4)));
String five = formatter.format(now.add(Duration(days: -5)));
String six = formatter.format(now.add(Duration(days: -6)));
String seven = formatter.format(now.add(Duration(days: -7)));

Future<List<Word>> getAllWords() async {
  List<String> dates = [one, two, three, four, five, six, seven];
  final response = await Future.wait(dates.map((d) => http.get(
      'https://api.wordnik.com/v4/words.json/wordOfTheDay?date=$d&api_key=$apiKey')));

  return response.map((r) {
    if (r.statusCode == 200) {
      return Word.fromJson(json.decode(r.body));
    } else {
      throw Exception('Failed to load word of the day.');
    }
  }).toList();
}

class Main extends StatefulWidget {
  static final _savedWords = SavedWords.savedWords;
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Future<List<Word>> futureWord;
  var _savedWords = Main._savedWords;
  @override
  void initState() {
    super.initState();
    futureWord = getAllWords();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          FutureBuilder<List<Word>>(
            future: futureWord,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Word> words = List<Word>();
                for (int i = 0; i < 7; i++) {
                  words.add(
                    Word(
                      word: snapshot.data[i].word,
                      definitions: [
                        Definition(
                          text: snapshot.data[i].definitions[0].text,
                          partOfSpeech:
                              snapshot.data[i].definitions[0].partOfSpeech,
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  child: Column(
                    children: words.map((word) => wordTemplate(word)).toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Could not get words :('),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget wordTemplate(word) {
    final alreadySaved = _savedWords.contains(word.word);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Card(
        color: Color(0xffffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5.0,
          ),
        ),
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${word.word[0].toUpperCase()}${word.word.substring(1)}',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.share),
                      IconButton(
                        icon: Icon(
                          alreadySaved ? Icons.favorite : Icons.favorite_border,
                          color: alreadySaved ? Colors.red : null,
                        ),
                        onPressed: () => {
                          setState(() {
                            if (alreadySaved) {
                              print('Removing: ' + word.word);
                              _savedWords.remove(word.word);
                              print(_savedWords);
                            } else {
                              print('Adding: ' + word.word);
                              _savedWords.add(word.word);
                              print(_savedWords);
                            }
                          })
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                word.definitions[0].partOfSpeech,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                word.definitions[0].text,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
