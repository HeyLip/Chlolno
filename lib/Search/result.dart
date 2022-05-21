import 'package:chlolno/LeagueStuff/game.dart';
import 'package:chlolno/LeagueStuff/summoner.dart';
import 'package:flutter/material.dart';
import 'package:chlolno/dart_lol.dart';


const String apikey = 'RGAPI-0bb6f5a8-221a-4c1f-941a-fb262a0fe90f';
const String server = 'kr';
int gameCount = 0;
final league = League(apiToken: apikey, server: server);
DateTime flagTime = DateTime.now();


Future<Summoner> getSummoner(String sumName) async{
  Summoner user;
  user = await league.getSummonerInfo(summonerName: sumName);
  return user;
} // summoner data 를 받아오는 부분
Future<List<Game>?> getGameHistory(Summoner user) async{
  List<Game>? gameList;
  gameList = await league.getGameHistory(puuid: user.puuid!, start: gameCount);
  gameCount = gameCount + 20;
  return gameList;
} // game history 를 받아오는 부분
Future<List<Game>?> updateGameHistory(List<Game>? games, Summoner user) async{
  List<Game>? gameList;
  gameList = await league.getGameHistory(puuid: user.puuid!, start: gameCount);
  gameCount = gameCount + 20;
  for(int i=0; i<20; i++){
    games!.add(gameList![i]);
  }
  return games;
}
DateTime championMet(List<Game>? games , String champName){
  DateTime championMet = flagTime;
  for(int i=0; i<games!.length; i++){
    if(games[i].champion!.contains(champName)){
      championMet = games[i].time!;
      championMet = championMet.add(const Duration(hours: 9));
      break;
    }
  }
  if(championMet == flagTime){
    return flagTime;
  }
  else{
    return championMet;
  }
}

class ResultPage extends StatefulWidget {
  final String name;
  const ResultPage({Key? key, required this.name}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
        centerTitle: true,
      ),
    );
  }
}