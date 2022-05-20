class Summoner {
  final String? summonerName;
  final int? level;
  final String? accID;
  final String? summonerID;
  final DateTime? lastTimeOnline;
  final int? profileIconID;
  final String? puuid;
  String? tier;
  String? rank;

  Summoner({
    this.summonerName,
    this.level,
    this.accID,
    this.summonerID,
    this.lastTimeOnline,
    this.puuid,
    this.profileIconID,
    this.tier,
    this.rank,
  });

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      summonerName: json['name'],
      level: json['summonerLevel'],
      summonerID: json['id'],
      accID: json['accountId'],
      lastTimeOnline: DateTime.fromMillisecondsSinceEpoch(json['revisionDate']),
      puuid: json['puuid'],
      profileIconID: json['profileIconId'],
    );
  }

  void setTierRank(String tier, String rank){
      this.tier = tier;
      this.rank = rank;
  }
}
