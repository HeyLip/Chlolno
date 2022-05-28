import 'package:flutter/material.dart';
import 'Login/login.dart';

class Chlolno extends StatelessWidget {
  const Chlolno({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chlolno',
      theme: ThemeData(
        primaryColor: const Color(0xFF2196F3), //앱의 전체 컬러를 설정합니다.
        appBarTheme: const AppBarTheme(
            color: Color(0xFF2196F3) //앱의 전체 컬러를 설정합니다.
        ),
      ),
      home: const LoginPage(), //app.dart를 실행하면 login.dart에 있는 LoginPage를 실행시킵니다.
    );
  }
}