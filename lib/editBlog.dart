import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:intl/intl.dart';
import 'package:quill_format/quill_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditBlog(),
  ));
}

class EditBlog extends StatefulWidget {
  const EditBlog({Key? key}) : super(key: key);

  @override
  State<EditBlog> createState() => EditBlogState();
}

class EditBlogState extends State<EditBlog> {

  var _formKey = GlobalKey<FormState>();
  ZefyrController _zefyrController = ZefyrController();

  TextEditingController _topicTitleController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref('blog/-N-Zn2llLxGhoBmVbtc5');
  
  Future<DataSnapshot?> _loadDocument() async {
    final snapshot = await ref.get();
    return snapshot;
  }

  @override
  void initState() {
    super.initState();
    _loadDocument().then((snapshot) {
      setState(() {
        if (snapshot != null) {
          _topicTitleController.value = _topicTitleController.value.copyWith(
            text: snapshot.child('title').value.toString(),
            selection: TextSelection.collapsed(offset: snapshot.child('title').value.toString().length),
          );
          _zefyrController = ZefyrController(
            NotusDocument.fromJson(
              jsonDecode(snapshot.child('content').value.toString())
              )
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = (_zefyrController == null)
    ? Container(
      child: Center(child: CircularProgressIndicator())
    )
    : Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  onPressed: () {}
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Edit Topic',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ]
            ),
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                        )
                      ),
                      controller: _topicTitleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Topic Title is required!';
                        }
                        return null;
                      }
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Content',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      )
                    ),
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
                        minimumSize: Size.fromHeight(50)
                      ),
                      child: Text('EDIT'), 
                      onPressed: () async {
                        if (_formKey.currentState!.validate() ||
                            _zefyrController.document.length > 0
                        ) 
                        {
                          await ref.update({
                            "author": "Sandy",
                            "title": _topicTitleController.text,
                            "content": jsonEncode(_zefyrController.document),
                            "created_at": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                          });
                        }
                      }
                    )
                  ],
                )
              )
            ),
          ],
        ),
      );
    
    return Scaffold(
      body: content,
    );
  }
}
