import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetail extends StatefulWidget {
  final String author;
  final String docId;
  final String title;
  final String detail;
  final Timestamp createTime;

  const PostDetail(
      {Key? key,
      required this.author,
      required this.docId,
      required this.title,
      required this.detail,
      required this.createTime})
      : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final _commentController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference database;
  late CollectionReference userDatabase;
  late CollectionReference commentsDatabase;
  late QuerySnapshot querySnapshot;

  @override
  void initState() {
    super.initState();
    database = FirebaseFirestore.instance.collection('Community');
    userDatabase = FirebaseFirestore.instance.collection('user');
    commentsDatabase = database.doc(widget.docId).collection("Comments");
  }

  List<Container> _commentsListCards(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    final ThemeData theme = Theme.of(context);

    return snapshot.data!.docs.map((DocumentSnapshot document) {
      // DateTime _dateTime = DateTime.parse(document['expirationDate'].toDate().toString());
      return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 300,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text(
                              document['name'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              document['comment'],
                              style: const TextStyle(fontSize: 15),
                              maxLines: 10,
                              softWrap: true,
                              overflow: TextOverflow.clip,
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.delete),
                    //   color: Colors.black,
                    //   onPressed: () {
                    //
                    //   },
                    // )
                  ],
                ),
              ),
            ],
          ));
    }).toList();
  }

  Widget likeSection(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () async {
                    int i;
                    QuerySnapshot querySnapshot = await database
                        .doc(widget.docId)
                        .collection('like_Users')
                        .get();

                    for (i = 0; i < querySnapshot.docs.length; i++) {
                      var a = querySnapshot.docs[i];

                      if (a.get('uid') == auth.currentUser?.uid) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("You can only do it once!!",
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ));
                        break;
                      }
                    }

                    if (i == (querySnapshot.docs.length)) {
                      database.doc(widget.docId).collection('like_Users').add({
                        'uid': auth.currentUser?.uid,
                      });

                      data['like'] = data['like'] + 1;

                      database.doc(widget.docId).update({
                        'like': data['like'],
                      });

                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //   duration: Duration(seconds: 2),
                      //   content: Text(
                      //     "I LIKE IT!",
                      //     style: TextStyle(fontSize: 20),
                      //   ),
                      // ));
                    }
                  },
                  icon: const Icon(
                    Icons.thumb_up,
                    size: 15,
                    color: Colors.red,
                  )),
              Text(
                '${data['like']}',
                style: const TextStyle(color: Colors.red, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
      // const FavoriteWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime _dateTime = DateTime.parse(widget.createTime.toDate().toString());
    Widget textSection(Map<String, dynamic> data) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.author,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                Text(
                  DateFormat('yyyy-MM-dd kk:mm').format(_dateTime),
                  style: const TextStyle(fontSize: 10),
                  softWrap: true,
                )
              ],
            ),
            const SizedBox(height: 10,),
            if (data['photoUrl'] != null)
              Image.network(data['photoUrl'],
                  width: MediaQuery.of(context).size.width, height: 320, fit: BoxFit.fitWidth),
            Text(
              widget.detail,
              style: const TextStyle(fontSize: 15),
              softWrap: true,
            )
          ],
        ),
      );
    }

    Widget _addComment() {
      return IconTheme(
        data: IconThemeData(color: Theme.of(context).backgroundColor),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration.collapsed(hintText: "Comment"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      querySnapshot = await userDatabase.get();
                      String name = '익명';

                      for (int i = 0; i < querySnapshot.docs.length; i++) {
                        var a = querySnapshot.docs[i];

                        if (a.get('uid') == auth.currentUser?.uid) {
                          name = a.get('name');
                        }
                      }

                      database.doc(widget.docId).collection("Comments").add({
                        'name': name,
                        'comment': _commentController.text,
                        'user_id': auth.currentUser?.uid,
                      });
                      _commentController.clear();
                    },
                  ),
                )
              ],
            )),
      );
    }

    return Scaffold(
      // resizeToAvoidBottomInset : false, // 화면 밀림 방지
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget> [
            Flexible(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  StreamBuilder<DocumentSnapshot>(
                    stream: database.doc(widget.docId).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {

                      Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: Text(''),
                          );
                        default:
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[textSection(data), likeSection(data)],
                          );
                      }
                    },
                  ),
                  // const Divider(
                  //   height: 2.0,
                  //   color: Colors.black,
                  // ),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: const Text(
                      'Comments',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: commentsDatabase.snapshots(),
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
                            child: Text(''),
                          );
                        default:
                          return Column(
                            // physics:  const ClampingScrollPhysics(),
                            //   physics: const NeverScrollableScrollPhysics (),
                            //   padding: const EdgeInsets.all(16.0),
                              children: _commentsListCards(
                                  context, snapshot) // Changed code
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _addComment(),
            )
          ],
        ),
      )
    );
  }
}
