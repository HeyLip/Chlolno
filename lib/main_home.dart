import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Community/community_home.dart';
import 'Search/search_home.dart';
import 'User/user_home.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference database = FirebaseFirestore.instance.collection('user');
  late QuerySnapshot querySnapshot; // 기존에 로그인한 것인지 아닌지를 확인하기위해 선언한 변수
  late bool anonymous;

  final List<Widget> _children = [const SearchHomePage(), const CommunityHomePage(), const UserHomePage()];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onTap,
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'MyPage',
              )
            ])

    );
  }
}
