import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemoDetail extends StatefulWidget {
  final String summonerName;
  final String champName;
  final String puuId;
  final String description;
  final Timestamp createTime;
  const MemoDetail({Key? key,
    required this.summonerName,
    required this.champName,
    required this.puuId,
    required this.description,
    required this.createTime}) : super(key: key);

  @override
  State<MemoDetail> createState() => _MemoDetailState();
}

class _MemoDetailState extends State<MemoDetail> {
  @override
  Widget build(BuildContext context) {
    DateTime _dateTime = DateTime.parse(widget.createTime.toDate().toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.summonerName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:  [
                const Text("작성일: "),
                Text(DateFormat('yyyy-MM-dd kk:mm').format(_dateTime))
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ClipOval(
                      child: widget.champName == "null" ? Image.network('https://firebasestorage.googleapis.com/v0/b/chlolno.appspot.com/o/%ED%8F%AC%EB%A1%9C.jpg?alt=media&token=91020fe6-eb71-49ee-8eee-616c6a78f801', fit: BoxFit.fill) :
                      Image.network( 'https://ddragon.leagueoflegends.com/cdn/12.9.1/img/champion/${widget.champName}.png', fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  widget.champName == "null" ? const Text('') :
                  Text(widget.champName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("메모 내용", style: TextStyle(fontSize: 18),),
                Text("- ${widget.description}", style: const TextStyle(fontSize: 20),)
              ],
            ),
          )
        ],
      )
    );
  }
}
