import 'dart:convert';
import 'package:blog_app/model/blogModel.dart';
import 'package:flutter/material.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DetailBlog(),
  ));
}

class DetailBlog extends StatefulWidget {
  const DetailBlog({Key? key}) : super(key: key);

  @override
  State<DetailBlog> createState() => DetailBlogState();
}

class DetailBlogState extends State<DetailBlog> {
  
  List<BlogModel> blogs = [];
  late ZefyrController _zefyrController;
  DatabaseReference ref = FirebaseDatabase.instance.ref('blog');
  
  Future<NotusDocument> _loadDocument() async {
    final snapshot = await ref.child('-N-ZqQmVcWn_C7O5PcEm').get();
    if (snapshot.exists) {
      final contents = snapshot.child('content').value.toString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta();
    return NotusDocument.fromDelta(delta);
  }

  @override
  void initState() {
    super.initState();
    _loadDocument().then((document) {
      setState(() {
        _zefyrController = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = (_zefyrController == null)
    ? Container(
      child: Center(child: CircularProgressIndicator())
    )
    : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () {}
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Blog',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {}
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {}
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10
            ),
            Expanded(
              child: Scrollbar(
                child: Column(
                  children: <Widget>[
                    Text('New Topic Haekfoamlekfnaoeifoaneoifaeinffieo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Expanded(
                      child: ZefyrEditor(
                        controller: _zefyrController,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: content
      ),
    );
  }
}

// floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       backgroundColor: Colors.black, 
      //       child: Icon(
      //         Icons.delete
      //       ),
      //       onPressed: () {
              
      //       },
      //       heroTag: null,
      //     ),
      //     SizedBox(
      //       height: 10,
      //     ),
      //     FloatingActionButton(   
      //       backgroundColor: Colors.black,        
      //       child: Icon(
      //         Icons.edit
      //       ),
      //       onPressed: () {

      //       },
      //       heroTag: null,
      //     )
      //   ]
      // )
