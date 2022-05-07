import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 비동기 실행을 위한 코드입니다.
  await Firebase.initializeApp();// Firebase 초기화
  runApp(
      const Chlolno()
  );
}