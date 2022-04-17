import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import './auth_services.dart';

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
  var _formKeyuser = GlobalKey<FormState>();
  var _formkeypass = GlobalKey<FormState>();
  bool hidePassword = true;
  DatabaseReference ref = FirebaseDatabase.instance.ref('user');

  TextEditingController _fieldusername = TextEditingController();
  TextEditingController _fieldpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Column(children: [
                Text(
                  "Go Blog",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                ),
              ]),
            ),
          ),
          Container(
              child: Form(
            key: _formKeyuser,
            child: Column(children: [
              Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _fieldusername,
                          autocorrect: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.person,
                                size: 35,
                              ),
                              labelText: 'Username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Masukan Username';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
              ),
            ]),
          )),
          Container(
              child: Form(
                  key: _formkeypass,
                  child: Column(children: [
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: Column(
                            children: [
                              TextFormField(
                                obscureText: hidePassword,
                                controller: _fieldpassword,
                                autocorrect: false,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: _togglePasswordview,
                                      child: Icon(
                                        Icons.visibility,
                                      ),
                                    ),
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: 35,
                                    ),
                                    labelText: 'Password'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Masukan Password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                    )
                  ]))),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKeyuser.currentState!.validate() &&
                        _formkeypass.currentState!.validate()) {
                      loginValidate();
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(400, 60),
                      primary: Colors.black,
                      onPrimary: Colors.white),
                ),
                TextButton(
                    onPressed: loginValidate,
                    child: Text('Already Have an account? Sign up',
                        textAlign: TextAlign.right))
              ]),
            ),
          )
        ]),
      ),
    );
  }

  void loginValidate() {
    print('kirim');

    print(AuthServices.signin(_fieldusername.text, _fieldpassword.text));
    print('dah kirim');
  }

  void _togglePasswordview() {
    if (hidePassword == true) {
      hidePassword = false;
    } else {
      hidePassword = true;
    }
    setState(() {});
  }
}
