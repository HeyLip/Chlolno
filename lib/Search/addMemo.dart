import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMemo extends StatefulWidget {
  final String summonerName;
  final String champName;
  final String puuId;
  const AddMemo({Key? key, required this.summonerName, required this.champName, required this.puuId}) : super(key: key);

  @override
  State<AddMemo> createState() => _AddMemoState();
}

class _AddMemoState extends State<AddMemo> {
  final _detailController = TextEditingController();
  late CollectionReference database;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    database = FirebaseFirestore.instance.collection('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Memo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: () {
              database.doc(auth.currentUser?.uid).collection('Memo').add({
                'summonerName': widget.summonerName,
                'description': _detailController.text,
                'champName' : widget.champName,
                'puuid': widget.puuId,
                'createTime': FieldValue.serverTimestamp(),
              });

              setState(() {
                Navigator.pop(context);
              });

            },
          ),
        ],
      ),

      body: Column(
        children: <Widget> [
          Container(
            padding: const EdgeInsets.all(40),
            child: Text(widget.summonerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          Expanded(
              child: ListView(
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextBox("Detail", _detailController),
                  ),
                ],
              )
          ),
          //Text(widget.puuId),
        ],
      ),
    );
  }

  TextField TextBox(String s, TextEditingController t) {
    return TextField(
      controller: t,
      minLines: 1,
      maxLines: 10,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: s,
      ),
    );
  }
}
