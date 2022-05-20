class Game {
  final String? gameID;
  final DateTime? time;
  final String? apiToken;
  final String? server;
  final List<String>? participant;
  final String? puuid;
  final List<String>? champion;
  final List<int>? championId;

  Game({
    this.gameID,
    this.time,
    this.apiToken,
    this.server,
    this.participant,
    this.puuid,
    this.champion,
    this.championId,
  });

  factory Game.fromJson(Map<String, dynamic> json, String apiToken, String? puuid, String? server) {
    return Game(
      gameID: json['metadata']['matchId'],
      time: DateTime.fromMillisecondsSinceEpoch(json['info']['gameEndTimestamp']),
      participant: participants(json),
      champion: champions(json),
      championId: championsId(json),
      apiToken: apiToken,
      server: server,
      puuid: puuid,
    );
  }
}

List<String> participants(Map<String, dynamic> json){
  List<String> participants = [];
  List<dynamic> dynList =  json['metadata']['participants'];
  participants = dynList.cast<String>();
  return participants;
}

List<String> champions(Map<String, dynamic> json){
  List<String> champions = [];
  List<dynamic> dynList =  json['info']['participants'];
  int length = dynList.length;
  for(int i=0; i<length; i++){
    champions.add(json['info']['participants'][i]['championName']);
  }

  return champions;
}

List<int> championsId(Map<String, dynamic> json){
  List<int> championsId = [];
  List<dynamic> dynList =  json['info']['participants'];
  int length = dynList.length;
  for(int i=0; i<length; i++){
    championsId.add(json['info']['participants'][i]['championId']);
  }

  return championsId;
}