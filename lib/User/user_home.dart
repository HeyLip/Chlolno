import 'package:chlolno/User/myPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Login/login.dart';
import 'myMemo.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference database = FirebaseFirestore.instance.collection('user');
  late QuerySnapshot querySnapshot;

  Future<void> deleteUser(User? _user) {
    return database
        .doc(_user!.uid)
        .delete()
        .catchError((error) => print("Failed to delete user: $error"));
  }
  @override
  Widget build(BuildContext context) {

    Future<bool> checkAnonymous() async{
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('user').doc(auth.currentUser?.uid).get();

      if(documentSnapshot['anonymous']){
        return true;
      }

      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget> [
          FutureBuilder<DocumentSnapshot>(
            future: database.doc(auth.currentUser?.uid).get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Something went wrong",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                );
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Center(
                    child: Text(
                      "Document does not exist",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ));
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

                return userSetting(data['email'], data['name']);
              }

              return const Center(
                  child: Text(
                    'Loading',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ));
            },
          ),

          FutureBuilder<bool> (
            future: checkAnonymous(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              if(snapshot.hasData){
                if(snapshot.data == false){
                  return SizedBox(
                    width: 350,
                    height: 70,
                    child: FloatingActionButton.extended(
                      backgroundColor: const Color(0xFF86B1E5),
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const MyMemo();
                            }));
                      },
                      label: const Text(
                        '내가 쓴 메모 보기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  );
                }
              }
              return const Text('');
            },
          ),

          const SizedBox(
            height: 20,
          ),

          FutureBuilder<bool> (
            future: checkAnonymous(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              if(snapshot.hasData){
                if(snapshot.data == false){
                  return SizedBox(
                    width: 350,
                    height: 70,
                    child: FloatingActionButton.extended(
                      backgroundColor: const Color(0xFF86B1E5),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const MyPost();
                            }));
                      },
                      label: const Text(
                        '내 게시글 보기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  );
                }
              }
              return const Text('');
            },
          ),

          const SizedBox(
            height: 20,
          ),


          SizedBox(
            width: 350,
            height: 70,
            child: FloatingActionButton.extended(
              backgroundColor: const Color(0xFF86B1E5),
              onPressed: () async {
                querySnapshot = await database.get();

                for(int i = 0; i < querySnapshot.docs.length; i++){
                  var a = querySnapshot.docs[i];

                  if(a.get('anonymous')){
                    deleteUser(auth.currentUser);
                    break;
                  }
                }

                await FirebaseAuth.instance.signOut();

                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return const LoginPage();
                    }));
              },
              label: const Text(
                '로그아웃',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
          ),


        ],
      ),
    );
  }

  Container userSetting(String email, String name) {
    return Container(
      height: 178,
      margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
      decoration: BoxDecoration(
          color: const Color(0xFFDCE4ED), borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        children: <Widget>[
          Container(
            width: 90,
            height: 90,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFB2DEB8)),
            child: ClipOval(
              child: Container(
                  color: Colors.white,
                  width: 100,
                  height: 100,
                  child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/chlolno.appspot.com/o/%EA%B8%B0%EB%B3%B8_%ED%94%84%EB%A1%9C%ED%95%84.jpg?alt=media&token=a002d8e8-e634-43ec-9b98-196925b7231a')),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Text(
                    "Email: $email",
                    style: const TextStyle(
                        fontSize: 16, color: Colors.black),
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Nickname: $name",
                    style: const TextStyle(
                        fontSize: 16, color: Colors.black),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
