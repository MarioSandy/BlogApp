import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CreateBlog(),
  ));
}

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => CreateBlogState();
}

class CreateBlogState extends State<CreateBlog> {
  var _formKey = GlobalKey<FormState>();
  ZefyrController _zefyrController = ZefyrController();

  TextEditingController _topicTitleController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref('blog');
  static FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back_outlined), onPressed: () {}),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'New Topic',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Topic Title',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Title',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                controller: _topicTitleController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Topic Title is required!';
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Content',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5,
                            ),
                            ZefyrToolbar.basic(controller: _zefyrController),
                            Expanded(
                              child: ZefyrEditor(
                                controller: _zefyrController,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    minimumSize: Size.fromHeight(50)),
                                child: Text('SUBMIT'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() ||
                                      _zefyrController.document.length > 0) {
                                    ref = ref.push();
                                    String? newKey = ref.key;
                                    await ref.set({
                                      "author": FirebaseAuth
                                          .instance.currentUser!.displayName,
                                      "title": _topicTitleController.text,
                                      "content":
                                          jsonEncode(_zefyrController.document),
                                      "created_at": DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                          .toString(),
                                    });
                                  }
                                })
                          ],
                        ))),
              ],
            )));
  }
}
