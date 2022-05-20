import 'package:flutter/material.dart';

class SearchHomePage extends StatefulWidget {

  const SearchHomePage({Key? key}) : super(key: key);

  @override
  _SearchHomePageState createState() => _SearchHomePageState();
}

class _SearchHomePageState extends State<SearchHomePage> {
  final TextEditingController _inputController =  TextEditingController();
  String inputText = "";
  List<String>? summonerNameList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Column(
          children: <Widget>[
            SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: TextField(
                        controller: _inputController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Input Summoner Name',
                          hintText: 'Enter Summoner names',
                        ),

                      ),
                    ),
                  ],
                ),
            ),
            ElevatedButton(
                onPressed: (){
                  inputText = _inputController.text;
                  summonerNameList = textCutter(inputText);
                  setState((){});

                  /*if(summonerNameList!.length == 1){
                    Navigator.pushNamed(context, 'Result');
                  }
                  else{
                    Navigator.pushNamed(context, 'MultiResult');
                  }
                   */
                },
                child: const Text('Search')
            ),
            const SizedBox(height: 50,),
          ],
      ),
    );
  }
}

List<String> textCutter(String text){
  List<String> tl;
  text.trim();
  tl = text.split(',');
  for(int i=0; i<tl.length; i++){
    tl[i] = tl[i].trim();
  }
  return tl;
}

