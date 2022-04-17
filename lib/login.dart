import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: login(),
  ));
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => loginState();
}

class loginState extends State<login> {
  var _formKey = GlobalKey<FormState>();
  DatabaseReference ref = FirebaseDatabase.instance.ref('user');

  TextEditingController _fieldusername = TextEditingController();
  TextEditingController _fieldpassword = TextEditingController();
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Form(
            key: _formKey,
            child: Column(children: []),
          ))
        ]),
      ),
    );
  }

  void validasi() {
    // username = _fieldusername.text;
    // password = _fieldpassword.text;
    // validasiusername();
    // validasipassword();
    // ref.child("user").set({'Nama': 'Budi', 'Umur': '12'});
  }
}
