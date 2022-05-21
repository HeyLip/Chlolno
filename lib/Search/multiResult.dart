import 'package:flutter/material.dart';
import 'package:chlolno/dart_lol.dart';
import 'package:chlolno/LeagueStuff/game.dart';
import 'package:chlolno/LeagueStuff/summoner.dart';

class MultiResultPage extends StatefulWidget {
  final List<String> names;
  const MultiResultPage({Key? key, required this.names}) : super(key: key);

  @override
  _MultiResultPageState createState() => _MultiResultPageState();
}

class _MultiResultPageState extends State<MultiResultPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Search'),
        centerTitle: true,
      ),
    );
  }
}