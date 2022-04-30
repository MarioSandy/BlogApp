import 'package:blog_app/createBlog.dart';
import 'package:blog_app/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './auth_services.dart';
import 'login.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => registerState();
}

class registerState extends State<register> {
  var _formKeyuser = GlobalKey<FormState>();
  var _formkeypass = GlobalKey<FormState>();
  var _formkeynama = GlobalKey<FormState>();
  var CurrentUser;
  bool hidePassword = true;
  static FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  TextEditingController _fieldusername = TextEditingController();
  TextEditingController _fieldpassword = TextEditingController();
  TextEditingController _fieldnama = TextEditingController();
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
                  "Register",
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
            key: _formkeynama,
            child: Column(children: [
              Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _fieldnama,
                          autocorrect: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.person,
                                size: 35,
                              ),
                              labelText: 'Nama Lengkap'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Masukan Nama Lengkap';
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
                        _formkeypass.currentState!.validate() &&
                        _formkeynama.currentState!.validate()) {
                      registerValidate();
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(400, 60),
                      primary: Colors.black,
                      onPrimary: Colors.white),
                ),
                TextButton(
                    onPressed: gotologin,
                    child: Text('Already Have an account? Login',
                        textAlign: TextAlign.right))
              ]),
            ),
          )
        ]),
      ),
    );
  }

  void registerValidate() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _fieldusername.text, password: _fieldpassword.text);
      CurrentUser = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(_fieldnama.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password too weak');
      } else if (e.code == 'email-already-in-use') {
        print('account already exists for that email');
      }
    } catch (e) {
      print(e);
    }
    print(FirebaseAuth.instance.currentUser!.displayName);

    // if (currentUser != null) {
    //   await ref
    //       .child('user/' + currentUser)
    //       .push()
    //       .set({'NamaLengkap': _fieldnama});
    //   print('berhasil');
    // }
  }

  void gotologin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
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
