import 'package:chlolno/LeagueStuff/game.dart';
import 'package:chlolno/LeagueStuff/summoner.dart';
import 'package:flutter/material.dart';
import 'package:chlolno/dart_lol.dart';

const String apikey = 'RGAPI-fe874f70-12cf-4e11-a2c8-fae1ad5e5d29';
const String server = 'kr';
int gameCount = 0;
final league = League(apiToken: apikey, server: server);
DateTime flagTime = DateTime.now();
bool  isPicked = false, isMet = false;

/*
Future<Summoner> getSummoner(String sumName) async {
  Summoner user;
  user = await league.getSummonerInfo(summonerName: sumName);
  return user;
}  // summoner data 를 받아오는 부분


Future<List<Game>?> getGameHistory(Summoner user) async {
  List<Game>? gameList;
  gameList = await league.getGameHistory(puuid: user.puuid!, start: gameCount);
  gameCount = gameCount + 100;
  return gameList;
}*/ // game history 를 받아오는 부분


Future<List<Game>?> updateGameHistory(dynamic games, String user) async {
  dynamic gameList;
  gameList = await league.getGameHistory(puuid: user, start: gameCount);
  gameCount = gameCount + 5;
  for (int i = 0; i < 5; i++) {
    games!.add(gameList![i]);
  }
  return games;
}

DateTime championMet(List<Game>? games, String champName) {
  DateTime championMet = flagTime;
  for (int i = 0; i < games!.length; i++) {
    if (games[i].champion!.contains(champName)) {
      championMet = games[i].time!;
      championMet = championMet.add(const Duration(hours: 9));
      break;
    }
  }
  if (championMet == flagTime) {
    isMet = false;
    return flagTime;
  } else {
    isMet = true;
    return championMet;
  }
}

DateTime getLastGameTime(List<Game>? games) {
  DateTime lastGameTime;
  lastGameTime = games![games.length-1].time!;
  lastGameTime = lastGameTime.add(const Duration(hours: 9));
  return lastGameTime;
}

class ResultPage extends StatefulWidget {
  final String name;
  const ResultPage({Key? key, required this.name}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  String championName = '';
  DateTime metTime = DateTime.now();

  late String userName = '';
  late var user;
  late var games;
  //late List<Game>? games;
  //late Summoner user;
/*user = await league.getSummonerInfo(summonerName: userName);
    games = await league.getGameHistory(puuid: user.puuid!, start: gameCount);
    */


  void initialize() async{
    user = await league.getSummonerInfo(summonerName: userName);
    print(user);
    games = await league.getGameHistory(puuid: user.puuid!, start: gameCount);
    gameCount = gameCount + 5;
    print(games);
    setState((){});
  }
  @override
  void initState() {
    super.initState();
    userName = widget.name;
    initialize();
  }

  static const champions = [
    'Aatrox', 'Ahri', 'Akali',
    'Akshan', 'Alistar', 'Amumu',
    'Anivia', 'Annie', 'Aphelios',
    'Ashe', 'AurelionSol', 'Azir',
    'Bard', 'Blitzcrank', 'Brand',
    'Braum', 'Caitlyn', 'Camille',
    'Cassiopeia', 'Chogath', 'Corki',
    'Darius', 'Diana', 'Draven',
    'DrMundo', 'Ekko', 'Elise',
    'Evelynn', 'Ezreal', 'Fiddlesticks',
    'Fiora', 'Fizz', 'Galio',
    'Gangplank', 'Garen', 'Gnar',
    'Gragas', 'Graves', 'Gwen',
    'Hecarim', 'Heimerdinger', 'Illaoi',
    'Irelia', 'Ivern', 'Janna',
    'JarvanIV', 'Jax', 'Jayce',
    'Jhin', 'Jinx', 'Kaisa',
    'Kalista', 'Karma', 'Karthus',
    'Kassadin', 'Katarina', 'Kayle',
    'Kayn', 'Kennen', 'Khazix',
    'Kindred', 'Kled', 'KogMaw',
    'Leblanc', 'LeeSin', 'Leona',
    'Lillia', 'Lissandra', 'Lucian',
    'Lulu', 'Lux', 'Malphite',
    'Malzahar', 'Maokai', 'MasterYi',
    'MissFortune', 'MonkeyKing', 'Mordekaiser',
    'Morgana', 'Nami', 'Nasus',
    'Nautilus', 'Neeko', 'Nidalee',
    'Nocturne', 'Nunu', 'Olaf',
    'Orianna', 'Ornn', 'Pantheon',
    'Poppy', 'Pyke', 'Qiyana',
    'Quinn', 'Rakan', 'Rammus',
    'RekSai', 'Rell', 'Renata',
    'Renekton', 'Rengar', 'Riven',
    'Rumble', 'Ryze', 'Samira',
    'Sejuani', 'Senna', 'Seraphine',
    'Sett', 'Shaco', 'Shen',
    'Shyvana', 'Singed', 'Sion',
    'Sivir', 'Skarner', 'Sona',
    'Soraka', 'Swain', 'Sylas',
    'Syndra', 'TahmKench', 'Taliyah',
    'Talon', 'Taric', 'Teemo',
    'Thresh', 'Tristana', 'Trundle',
    'Tryndamere', 'TwistedFate', 'Twitch',
    'Udyr', 'Urgot', 'Varus',
    'Vayne', 'Veigar', 'Velkoz',
    'Vex', 'Vi', 'Viego',
    'Viktor', 'Vladimir', 'Volibear',
    'Warwick', 'Xayah', 'Xerath',
    'XinZhao', 'Yasuo', 'Yone',
    'Yorick', 'Yuumi', 'Zac',
    'Zed', 'Zeri', 'Ziggs',
    'Zilean', 'Zoe', 'Zyra'
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text('Champions'),
          isPicked
          ? isMet ? SizedBox(width:250, height:70, child: Text('$userName님은 $championName챔피언을 \n$metTime에\n 마지막으로 만나셨습니다.'))
                  : SizedBox(width:250, height:70, child: Text('$userName님은 $championName챔피언을 \n$metTime이후에\n 만난 적이 없습니다.'))
              : const Text('챔피언을 골라주세요.'),
          ElevatedButton(
              onPressed: () async{
                games = await updateGameHistory(games, user.puuid);
                setState((){});
              },
              child: Text('Update 5 games / Total Elements: $gameCount'),


          ),
          Expanded(
            child: GridView.builder(
              itemCount: champions.length, //item 개수
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, //1 개의 행에 보여줄 item 개수
                childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                mainAxisSpacing: 5, //수평 Padding
                crossAxisSpacing: 5, //수직 Padding
              ),
              itemBuilder: (BuildContext context, int index) {
                //item 의 반목문 항목 형성
                return GestureDetector(
                  onTap: () {
                    isMet = false;
                    championName = champions.elementAt(index);
                    isPicked = true;
                    metTime = championMet(games, championName);
                    if(isMet != true){
                      metTime = getLastGameTime(games);
                    }
                    setState((){});
                  },
                  child: Column(
                    children: [
                      Image.network(
                        'https://ddragon.leagueoflegends.com/cdn/12.9.1/img/champion/${champions.elementAt(index)}.png',
                        height: 50,
                        width: 50,
                      ),
                      /*Expanded(
                        child: Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: Text(
                            champions.elementAt(index),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
