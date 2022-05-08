import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class UserHomePage extends StatefulWidget {

  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late CollectionReference database;

  List<InkWell> _buildListCards(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    final ThemeData theme = Theme.of(context);

    return snapshot.data!.docs.map((DocumentSnapshot document) {
      DateTime _dateTime =
      DateTime.parse(document['expirationDate'].toDate().toString());
      return InkWell(
        onTap: () {
          // dialog(document['photoUrl'], document['productName'], _dateTime,
          //     document['description']);
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFB2DEB8),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipOval(
                    child:
                    Image.network(document['photoUrl'], fit: BoxFit.fill),
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
                      Text(
                        document['productName'],
                        style: theme.textTheme.headline6,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '${DateFormat('yyyy').format(_dateTime)}.${_dateTime.month}.${_dateTime.day}',
                        style: theme.textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                IconButton(
                    icon: const Icon(
                      Icons.delete,
                    ),
                    iconSize: 30,
                    color: Colors.white,
                    onPressed: () async {
                      database.doc(document.id).delete();
                      FirebaseStorage.instance
                          .refFromURL(document['photoUrl'])
                          .delete();
                    }),
              ],
            )),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[

        ],
      ),

    );
  }
}