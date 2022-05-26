import 'package:flutter/material.dart';
import 'package:chlolno/dart_lol.dart';
import 'package:chlolno/LeagueStuff/game.dart';
import 'package:chlolno/LeagueStuff/summoner.dart';

const String apikey = 'RGAPI-80ed21b5-7a3e-4ccf-9786-64e751a14592';
const String server = 'kr';
int gameCount = 0;
final league = League(apiToken: apikey, server: server);
DateTime flagTime = DateTime.now();


Future<Summoner?> getSummoner(String sumName) async{
  Summoner? user;
  user = await league.getSummonerInfo(summonerName: sumName);
  return user;
} // summoner data 를 받아오는 부분
Future<List<Game>?> getGameHistory(Summoner user) async{
  List<Game>? gameList;
  gameList = await league.getGameHistory(puuid: user.puuid!, start: gameCount);
  gameCount = gameCount + 100;
  return gameList;
} // game history 를 받아오는 부분
Future<List<Game>?> updateGameHistory(List<Game>? games, Summoner user) async{
  List<Game>? gameList;
  gameList = await league.getGameHistory(puuid: user.puuid!, start: gameCount);
  gameCount = gameCount + 100;
  for(int i=0; i<20; i++){
    games!.add(gameList![i]);
  }
  return games;
}


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