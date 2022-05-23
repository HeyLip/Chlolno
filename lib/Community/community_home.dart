import 'package:chlolno/Community/post_Detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addPost.dart';

class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({Key? key}) : super(key: key);

  @override
  _CommunityHomePageState createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  late CollectionReference database;

  @override
  void initState() {
    super.initState();
    database = FirebaseFirestore.instance.collection('Community');
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
                return PostDetail(
                  author: document['author'],
                  docId: document.id,
                  title: document['title'],
                  detail: document['detail'],
                  createTime: document['createTime'],
                );
              }));
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
              color: Color(0xFFB2DEB8),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 28,
                      color: Colors.red,
                    ),
                    Text(
                      document['like'].toString(),
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                  ],
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
                      Text(
                        document['title'],
                        style: theme.textTheme.headline6,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return const AddPost();
              }));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: database.snapshots(),
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
