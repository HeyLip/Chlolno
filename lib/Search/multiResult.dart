import 'package:flutter/material.dart';
import 'package:chlolno/dart_lol.dart';
import 'package:chlolno/LeagueStuff/game.dart';
import 'package:chlolno/LeagueStuff/summoner.dart';
import 'package:chlolno/LeagueStuff/ingame.dart';
import 'package:chlolno/LeagueStuff/champ.dart';

const String apikey = 'RGAPI-55e80a10-caac-4606-8ae8-20c7dacc8854';
const String server = 'kr';
int gameCount = 0;
final league = League(apiToken: apikey, server: server);
DateTime flagTime = DateTime.now();
bool isPicked = false, isMet = false;
int inGamePrintCounter = 0;

Future<Summoner?> getSummoner(String sumName) async {
  Summoner? user;
  user = await league.getSummonerInfo(summonerName: sumName);
  return user;
} // summoner data 를 받아오는 부분

Future<List<Game>?> getGameHistory(Summoner? user) async {
  List<Game>? gameList;
  gameList = await league.getGameHistory(puuid: user!.puuid!, start: gameCount);
  gameCount = gameCount + 5;
  return gameList;
} // game history 를 받아오는 부분

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
  lastGameTime = games![games.length - 1].time!;
  lastGameTime = lastGameTime.add(const Duration(hours: 9));
  return lastGameTime;
}

Future<List<InGame>?> getCurrentGame(Summoner user) async {
  List<InGame>? userList;
  userList = await league.getCurrentGame(
      userName: user.summonerName!, userId: user.summonerID!);
  if (userList == null) {
    userList!.clear();
    return userList;
  } else {
    userList.sort((a, b) => a.teamID!.compareTo(b.teamID!));
    return userList;
  }
}

String getNameById(int champID) {
  var champIDs = getChampIDs();
  var idx = champIDs.indexOf(champID);
  var champNames = getChampNames();
  return champNames[idx];
}

class MultiResultPage extends StatefulWidget {
  final List<String> names;
  const MultiResultPage({Key? key, required this.names}) : super(key: key);

  @override
  _MultiResultPageState createState() => _MultiResultPageState();
}

class _MultiResultPageState extends State<MultiResultPage> {
  Future? myFuture;
  late List<String> userNames;

  Future initialize() async {
    Summoner? add;
    List<Summoner?> users = [];
    for (int i = 0; i < userNames.length; i++) {
      add = await getSummoner(userNames[i]);
      if (add == null) {
        _showDialog(userNames[i]);
      } else {
        users.add(add);
      }
    }
    print('this is summoner list');
    setState(() {});
    return users;
  }

  @override
  void initState() {
    super.initState();
    userNames = widget.names;
    myFuture = initialize();
  }

  void _showDialog(String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("주 의"),
          content: Text("$userName 해당 유저를 찾을 수 없습니다."),
          actions: <Widget>[
            TextButton(
              child: const Text("돌아가기"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildRowContext(users) {
    List<Widget> rowList = [];
    for (int i = 0; i < users.length; i++) {
      String tier = users[i].tier;
      rowList.add(Card(
        child: ListTile(
          leading: Image.asset(
            'assets/tier/$tier.png',
            height: 50,
            width: 50,
            fit: BoxFit.fitWidth,
          ),
          title: Text(
            users[i].summonerName,
            style: const TextStyle(fontSize: 25),
          ),
          trailing: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MResultPage(
                            name: users[i].summonerName, names: userNames)));
              },
              child: const Text(
                'Info',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              )),
        ),
      ));
    }
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Search'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
            future: myFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              } else {
                return Column(
                  children: _buildRowContext(snapshot.data),
                );
              }
            }),
      ),
    );
  }
}

class MResultPage extends StatefulWidget {
  final String name;
  final List<String> names;
  const MResultPage({Key? key, required this.name, required this.names})
      : super(key: key);

  @override
  _MResultPageState createState() => _MResultPageState();
}

class _MResultPageState extends State<MResultPage> {
  String championName = '';
  DateTime metTime = DateTime.now();
  late String userName = '';
  late Summoner? user;
  late List<Game>? games;
  List<InGame>? userList;
  Future? myFuture;
  Future initialize() async {
    user = await getSummoner(userName);
    if (user == null) {
      _showDialog();
    } else {
      games = await getGameHistory(user);
      setState(() {});
    }
    return user;
  }

  @override
  void initState() {
    super.initState();
    userName = widget.name;
    isPicked = false;
    isMet = false;
    gameCount = 0;
    myFuture = initialize();
  }

  static const champions = [
    'Aatrox',
    'Ahri',
    'Akali',
    'Akshan',
    'Alistar',
    'Amumu',
    'Anivia',
    'Annie',
    'Aphelios',
    'Ashe',
    'AurelionSol',
    'Azir',
    'Bard',
    'Blitzcrank',
    'Brand',
    'Braum',
    'Caitlyn',
    'Camille',
    'Cassiopeia',
    'Chogath',
    'Corki',
    'Darius',
    'Diana',
    'Draven',
    'DrMundo',
    'Ekko',
    'Elise',
    'Evelynn',
    'Ezreal',
    'Fiddlesticks',
    'Fiora',
    'Fizz',
    'Galio',
    'Gangplank',
    'Garen',
    'Gnar',
    'Gragas',
    'Graves',
    'Gwen',
    'Hecarim',
    'Heimerdinger',
    'Illaoi',
    'Irelia',
    'Ivern',
    'Janna',
    'JarvanIV',
    'Jax',
    'Jayce',
    'Jhin',
    'Jinx',
    'Kaisa',
    'Kalista',
    'Karma',
    'Karthus',
    'Kassadin',
    'Katarina',
    'Kayle',
    'Kayn',
    'Kennen',
    'Khazix',
    'Kindred',
    'Kled',
    'KogMaw',
    'Leblanc',
    'LeeSin',
    'Leona',
    'Lillia',
    'Lissandra',
    'Lucian',
    'Lulu',
    'Lux',
    'Malphite',
    'Malzahar',
    'Maokai',
    'MasterYi',
    'MissFortune',
    'MonkeyKing',
    'Mordekaiser',
    'Morgana',
    'Nami',
    'Nasus',
    'Nautilus',
    'Neeko',
    'Nidalee',
    'Nocturne',
    'Nunu',
    'Olaf',
    'Orianna',
    'Ornn',
    'Pantheon',
    'Poppy',
    'Pyke',
    'Qiyana',
    'Quinn',
    'Rakan',
    'Rammus',
    'RekSai',
    'Rell',
    'Renata',
    'Renekton',
    'Rengar',
    'Riven',
    'Rumble',
    'Ryze',
    'Samira',
    'Sejuani',
    'Senna',
    'Seraphine',
    'Sett',
    'Shaco',
    'Shen',
    'Shyvana',
    'Singed',
    'Sion',
    'Sivir',
    'Skarner',
    'Sona',
    'Soraka',
    'Swain',
    'Sylas',
    'Syndra',
    'TahmKench',
    'Taliyah',
    'Talon',
    'Taric',
    'Teemo',
    'Thresh',
    'Tristana',
    'Trundle',
    'Tryndamere',
    'TwistedFate',
    'Twitch',
    'Udyr',
    'Urgot',
    'Varus',
    'Vayne',
    'Veigar',
    'Velkoz',
    'Vex',
    'Vi',
    'Viego',
    'Viktor',
    'Vladimir',
    'Volibear',
    'Warwick',
    'Xayah',
    'Xerath',
    'XinZhao',
    'Yasuo',
    'Yone',
    'Yorick',
    'Yuumi',
    'Zac',
    'Zed',
    'Zeri',
    'Ziggs',
    'Zilean',
    'Zoe',
    'Zyra'
  ];

  Widget _buildRowContext(userList) {
    String champName = getNameById(userList.championID);
    inGamePrintCounter++;
    if (inGamePrintCounter == 6) {
      return Column(
        children: [
          const Divider(
            indent: 15,
            endIndent: 15,
            thickness: 2,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 50,
              ),
              Image.network(
                'https://ddragon.leagueoflegends.com/cdn/12.9.1/img/champion/$champName.png',
                height: 30,
                width: 30,
              ),
              Text(userList.summonerName),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 50,
          ),
          Image.network(
            'https://ddragon.leagueoflegends.com/cdn/12.9.1/img/champion/$champName.png',
            height: 30,
            width: 30,
          ),
          Text(userList.summonerName),
        ],
      );
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("주 의"),
          content: const Text("유저를 찾을 수 없습니다."),
          actions: <Widget>[
            TextButton(
              child: const Text("돌아가기"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        // 탭의 수 설정
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Search Result'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(child: Text('Champion')),
                Tab(child: Text('InGame')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  FutureBuilder(
                    future: myFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        );
                      } else {
                        return Card(
                          child: ListTile(
                            leading: Image.asset(
                              'assets/tier/${snapshot.data.tier}.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.fitWidth,
                            ),
                            title: Text(
                              snapshot.data.summonerName,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  isPicked
                      ? isMet
                          ? SizedBox(
                              width: 250,
                              height: 70,
                              child: Text(
                                  '$userName님은 $championName챔피언을 \n$metTime에\n 마지막으로 만나셨습니다.'))
                          : SizedBox(
                              width: 250,
                              height: 70,
                              child: Text(
                                  '$userName님은 $championName챔피언을 \n$metTime이후에\n 만난 적이 없습니다.'))
                      : const Text('챔피언을 골라주세요.'),
                  ElevatedButton(
                    onPressed: () async {
                      games =
                          await updateGameHistory(games, user!.puuid!); // 5게임 더
                      setState(() {}); // 화면다시그리기
                    },
                    child: Text('Update 5 games / Total Elements: $gameCount'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: champions.length, //item 개수
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6, //1 개의 행에 보여줄 item 개수
                        childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                        mainAxisSpacing: 5, //수평 Padding
                        crossAxisSpacing: 5, //수직 Padding
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        //item 의 반목문 항목 형성
                        return GestureDetector(
                          onTap: () {
                            isMet = false; // 만났니?변수 초기화
                            championName =
                                champions.elementAt(index); // 고른챔피언이뭐야
                            isPicked = true; // 골랐어.
                            metTime = championMet(games, championName); // 언제만났어
                            if (isMet != true) {
                              metTime = getLastGameTime(games); // 마지막게임시간
                            } // 안만났으면?
                            setState(() {}); // 화면다시그리기
                          },
                          child: Column(
                            children: [
                              Image.network(
                                'https://ddragon.leagueoflegends.com/cdn/12.9.1/img/champion/${champions.elementAt(index)}.png',
                                height: 60,
                                width: 60,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  userList == null
                      ? const Text('게임 중이 아닙니다.')
                      : Column(
                          children: userList!
                              .map((userList) => _buildRowContext(userList))
                              .toList(),
                        ),
                  ElevatedButton(
                    onPressed: () async {
                      userList = await league.getCurrentGame(
                          userName: user!.summonerName!,
                          userId: user!.summonerID!);
                      inGamePrintCounter = 0;
                      setState(() {});
                    },
                    child: const Text('불러오기'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
