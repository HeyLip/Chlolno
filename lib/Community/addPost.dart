import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference database;

  @override
  void initState() {
    super.initState();
    database = FirebaseFirestore.instance
        .collection('Community');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget> [

          Container(
            padding: const EdgeInsets.all(20.0),
            child: TextBox("Title", _titleController),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextBox("Detail", _detailController),
          ),
          cancelSaveButton(),
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

  Row cancelSaveButton() {
    return Row(children: [
      Expanded(
        child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "취소",
              style: TextStyle(color: Colors.black),
            )),
      ),
      Expanded(
        child: TextButton(
            onPressed: () async {

              database.add({
                'title': _titleController.text,
                'detail': _detailController.text,
                'user_id': auth.currentUser?.uid,
                'like': 0
              });

              setState(() {
                Navigator.pop(context);
              });
            },
            child: const Text(
              "저장",
              style: TextStyle(color: Colors.blue),
            )),
      ),
    ]);
  }
}
