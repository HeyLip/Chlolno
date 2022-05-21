
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'LeagueStuff/game.dart';
import 'LeagueStuff/summoner.dart';

class League {
  String apiToken;
  String? server;

  Map<String, String> serverMap = {
    'na1': 'americas',
    'br1': 'americas',
    'la1': 'americas',
    'la2': 'americas',
    'oc1': 'americas',
    'euw1': 'europe',
    'eun1': 'europe',
    'tr1': 'europe',
    'ru': 'europe',
    'kr': 'asia',
    'jp1': 'asia',
  };
  List<Game>? gameList;

  League({required this.apiToken, required String server}) {
    this.server = server.toLowerCase();
  }

  Future<Summoner> getSummonerInfo({String? summonerName}) async {
    var url1 =
        'https://$server.api.riotgames.com/lol/summoner/v4/summoners/by-name/$summonerName?api_key=$apiToken';
    var response1 = await http.get(
      Uri.parse(url1),
    );
    Summoner sum = Summoner.fromJson(json.decode(response1.body,),);
    String? sumId = sum.summonerID;
    
    var url2 =
        'https://$server.api.riotgames.com/lol/league/v4/entries/by-summoner/$sumId?api_key=$apiToken';
    var response2 = await http.get(
      Uri.parse(url2),
    );
    if (response2.body.toString() != '[]') {
      Map<String, dynamic> dynList = jsonDecode(response2.body,)[0];
      sum.setTierRank(dynList['tier'], dynList['rank']);
    }
    else{
      sum.setTierRank('unranked', 'no tier');
    }
    return sum;
  }

  Future<List<Game>?> getGameHistory(
      {required String puuid, required int start, int count = 100}) async {
    var url =
        'https://${serverMap[server]}.api.riotgames.com/lol/match/v5/matches/by-puuid/$puuid/ids?start=$start&count=$count&api_key=$apiToken';
    var response = await http.get(
      Uri.parse(url),
    );
    List<dynamic> matchIdList = json.decode(response.body);
    print(matchIdList);

    gameList = [];
    for (String id in matchIdList) {
      var url = 'https://${serverMap[server]}.api.riotgames.com/lol/match/v5/matches/$id?api_key=$apiToken';
      var response = await http.get(
        Uri.parse(url),
      );
      final match = json.decode(response.body);
      gameList!.add(
        Game.fromJson(json.decode(json.encode(match)), apiToken, puuid, server),
      );
    }
    return gameList;
  }
}
