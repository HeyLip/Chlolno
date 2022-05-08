import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  CollectionReference database = FirebaseFirestore.instance.collection('user');
  late QuerySnapshot querySnapshot; // 기존에 로그인한 것인지 아닌지를 확인하기위해 선언한 변수

  int alphabetCount(){
    int count = 0;
    List<String> alphabet = ['a', 'b', 'c', 'd', 'e','f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u','v', 'w', 'x', 'y', 'z'];
    List<String> s = _usernameController.text.toLowerCase().split('');
    for(int i = 0; i < _usernameController.text.length; i++){
      for(int j = 0; j < alphabet.length; j++){
        if(s[i] == alphabet[j]){
          count++;
        }
      }
    }
    return count;
  }

  int numberCount(){
    int count = 0;
    List<String> numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    List<String> s = _usernameController.text.split('');
    for(int i = 0; i < _usernameController.text.length; i++){
      for(int j = 0; j < numbers.length; j++){
        if(s[i] == numbers[j]){
          count++;
        }
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                const SizedBox(height: 30.0),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email Address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                TextFormField(
                  controller: _confirmController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Confirm Password';
                    }else if(_passwordController.text != _confirmController.text){
                      return 'Confirm Password doesn\'t match Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                ButtonBar(
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xffE0E0E0)),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      child: const Text('SIGN UP'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {

                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text
                          );
                          User? user = userCredential.user;

                          if (user != null) { // <- 로그인했는지 아닌지 확인히는 부분
                            int i;
                            querySnapshot = await database.get();

                            for(i = 0; i < querySnapshot.docs.length; i++){
                              var a = querySnapshot.docs[i];

                              if(a.get('uid') == user.uid){
                                break;
                              }
                            }

                            if(i == (querySnapshot.docs.length)){ // <- user의 이메일, 이름 그리고 firebase에 로그인할 때, 생기는 uid를 넣어줍니다.
                              database.doc(user.uid).set({
                                'email': user.email.toString(),
                                'name': _usernameController.text,
                                'uid': user.uid,
                              });
                            }
                          }

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
