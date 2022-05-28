import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  PickedFile? _image;
  late Reference firebaseStorageRef;
  late QuerySnapshot querySnapshot;
  late CollectionReference userDatabase;
  late UploadTask uploadTask;
  late var downloadUrl;

  FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference database;

  @override
  void initState() {
    super.initState();
    database = FirebaseFirestore.instance
        .collection('Community');
    userDatabase = FirebaseFirestore.instance.collection('user');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
          children: <Widget> [
            Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: TextBox("Title", _titleController),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextBox("Detail", _detailController),
                    ),
                  ],
                )
            ),
            getImageButton(),
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

  Row getImageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget> [
        FloatingActionButton(
          onPressed: () async {
            var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
            setState(() {
              _image = image!;
            });
          },
          tooltip: 'Pick Image',
          child: const Icon(Icons.wallpaper),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 150,
          child: Center(
            child: _image == null
                ? const Text('No image selected.')
                : Image.file(File(_image!.path)),
          ),
        )
      ],
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
              querySnapshot = await userDatabase.get();
              String name = '익명';
              downloadUrl = null;

              if(_image != null){
                firebaseStorageRef = firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child('Community')
                    .child('${_titleController.text}.png');

                uploadTask = firebaseStorageRef.putFile(File(_image!.path), SettableMetadata(contentType: 'image/png'));

                await uploadTask.whenComplete(() => null);

                downloadUrl = await firebaseStorageRef.getDownloadURL();
              }

              for (int i = 0; i < querySnapshot.docs.length; i++) {
                var a = querySnapshot.docs[i];

                if (a.get('uid') == auth.currentUser?.uid) {
                  name = a.get('name');
                }
              }

              database.add({
                'title': _titleController.text,
                'detail': _detailController.text,
                'author': name,
                'user_id': auth.currentUser?.uid,
                'createTime': FieldValue.serverTimestamp(),
                'photoUrl': downloadUrl,
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
