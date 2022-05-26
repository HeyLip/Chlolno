class InGame {
  final int? teamID;
  final int? championID;
  final String? summonerName;
  //final List<dynamic>? participant;
  InGame({
    this.teamID,
    this.championID,
    this.summonerName,
    //this.participant,
  });

  factory InGame.fromJson(Map<String, dynamic> json, int index) {
    return InGame(
      //participant: json['participants'],
      teamID: json['participants'][index]['teamId'],
      championID: json['participants'][index]['championId'],
      summonerName: json['participants'][index]['summonerName'],
    );
  }
}

/*int getTeamId(Map<String, dynamic> json, int index){
  int teamId;
  teamId = json[index]['teamId'];
  return teamId;
}
int getChampionId(Map<String, dynamic> json, int index){
  int championId;
  championId = json[index]['championId'];
  return championId;
}
String getSummonerName(Map<String, dynamic> json, int index){
  String summonerName;
  summonerName = json[index]['summonerName'];
  return summonerName;
}*/