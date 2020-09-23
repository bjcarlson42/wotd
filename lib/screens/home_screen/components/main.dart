import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wotd/key.dart';
import 'dart:convert';
import 'package:wotd/models/word.dart';
import 'package:wotd/models/saved_words.dart';

var now = new DateTime.now();
var formatter = new DateFormat('yyyy-MM-dd');
String today = formatter.format(now);

final String url = 'https://api.wordnik.com/v4/words.json/wordOfTheDay?date=' +
    today +
    '&api_key=' +
    apiKey;

Future<Word> fetchWord() async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Word.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load word.');
  }
}

class Main extends StatefulWidget {
  static final _savedWords = SavedWords.savedWords;
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Future<Word> futureWord;
  var _savedWords = Main._savedWords;
  @override
  void initState() {
    super.initState();
    futureWord = fetchWord();
  }

  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      child: Card(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<Word>(
                future: futureWord,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${snapshot.data.word[0].toUpperCase()}${snapshot.data.word.substring(1)}',
                              style: TextStyle(
                                fontSize: 45,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.mic,
                              size: 35.0,
                            ),
                          ],
                        ),
                        Text(
                          snapshot.data.definitions[0].partOfSpeech,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          snapshot.data.definitions[0].text,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        buildRow(snapshot.data.word),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Could not fetch word of the day :(');
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(word) {
    final alreadySaved = _savedWords.contains(word);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
                print('Removing: ' + word);
                _savedWords.remove(word);
                print(_savedWords);
              } else {
                print('Adding: ' + word);
                _savedWords.add(word);
                print(_savedWords);
              }
            })
          },
        ),
      ],
    );
  }
}
