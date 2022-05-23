class InGame {
  final int? teamID;
  final int? championID;
  final String? summonerName;

  InGame({
    this.teamID,
    this.championID,
    this.summonerName,
  });

  factory InGame.fromJson(Map<String, dynamic> json, int index) {
    return InGame(
      teamID: json['participants'][index]['teamId'],
      championID: json['participants'][index]['championId'],
      summonerName: json['participants'][index]['summonerName'],
    );
  }
}