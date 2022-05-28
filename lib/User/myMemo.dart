import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'memo_Detail.dart';

class MyMemo extends StatefulWidget {
  const MyMemo({Key? key}) : super(key: key);

  @override
  State<MyMemo> createState() => _MyMemoState();
}

List<InkWell> _buildListCards(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  final ThemeData theme = Theme.of(context);

  return snapshot.data!.docs.map((DocumentSnapshot document) {
    // DateTime _dateTime = DateTime.parse(document['expirationDate'].toDate().toString());
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return MemoDetail(
                summonerName: document['summonerName'],
                champName: document['champName'],
                puuId: document['puuid'],
                description: document['description'],
                createTime: document['createTime'],
              );
            }));
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            color: Color(0xFFDCE4ED),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: ClipOval(
                  child: document['champName'] == "null" ? Image.network('https://firebasestorage.googleapis.com/v0/b/chlolno.appspot.com/o/%ED%8F%AC%EB%A1%9C.jpg?alt=media&token=91020fe6-eb71-49ee-8eee-616c6a78f801', fit: BoxFit.fill) :
                  Image.network( 'https://ddragon.leagueoflegends.com/cdn/12.9.1/img/champion/${document['champName']}.png', fit: BoxFit.fill),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 174,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Summoner Name",
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      document['summonerName'],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
          )),
    );
  }).toList();
}


class _MyMemoState extends State<MyMemo> {
  late CollectionReference database;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    database = FirebaseFirestore.instance
        .collection('user').doc(auth.currentUser?.uid).collection('Memo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memo'),
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: database.orderBy('createTime', descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: Text('Loading...'),
                    );
                  default:
                    return ListView(
                        padding: const EdgeInsets.all(16.0),
                        children:
                        _buildListCards(context, snapshot) // Changed code
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
