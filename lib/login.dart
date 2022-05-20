
import 'package:chlolno/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_home.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  CollectionReference database = FirebaseFirestore.instance.collection('user'); // 연결된 Firebase에 user라는 collection에 접근하기 위한 변수
  late QuerySnapshot querySnapshot; // 기존에 로그인한 것인지 아닌지를 확인하기위해 선언한 변수

  //----------google login을 위한 함수-----------------------------------------------
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  //--------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const SizedBox(height: 100.0),
          Column(
            children: [
              Container(
                // padding: EdgeInsets.fromLTRB(0, 320, 0, 330),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: const Text(
                  "Chlolno",
                  style: TextStyle(
                    letterSpacing: 0.3,
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset('assets/logo.png', width: 160, height: 73,),
              const SizedBox(height: 16.0),
            ],
          ),
          const SizedBox(height: 30.0),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          // --------------------- Email login button ------------------------------
          const SizedBox(height: 10,),
          SignInButtonBuilder(
            text: 'Sign in with Email', //button의 문구를 결정하는 부분
            icon: Icons.email_outlined,
            backgroundColor: Colors.blue.shade600,
            onPressed: () async { // <- button을 눌렀을 때, 어떤 기능을 수행하는지 구현하는 부분

              final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
              User? user = userCredential.user;

              if (user != null) { // <- 로그인했는지 아닌지 확인히는 부분

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainHomePage(),
                  ),
                );

              }
            },
          ),



          // ---------------------- google login button ----------------------------
          SignInButton(
            Buttons.GoogleDark,
            onPressed: () async { // <- button을 눌렀을 때, 어떤 기능을 수행하는지 구현하는 부분

              //-------로그인 버튼을 눌렀을 때, 기존에 로그인했던 아이디이면 그냥 넘어가고 처음 로그인한 아이디이면 user collection에 user에 정보들을 추가합니다.--------------
              final UserCredential userCredential = await signInWithGoogle();

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
                    'name': user.displayName.toString(),
                    'uid': user.uid,
                  });
                }
                //--------------------------------------------------------------------------

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainHomePage(),
                  ),
                );
              }
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: (){

                    Navigator.push(context,
                        MaterialPageRoute<void>(builder: (BuildContext context) {
                          return const SignPage(
                          );
                        }));

                  }, child: const Text("Sign Up")
              ),
            ],

          ),
        ],
      ),
    );
  }
}
