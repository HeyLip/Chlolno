import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMemo extends StatefulWidget {
  const MyMemo({Key? key}) : super(key: key);

  @override
  State<MyMemo> createState() => _MyMemoState();
}

class _MyMemoState extends State<MyMemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memo'),
        centerTitle: true,
      ),
    );
  }
}
