import 'package:blog_app/model/blogModel.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));

// Widget blogCardWithImage(blog) {
//   return Card(
//     child: ListTile(
//       title: Text(blog.title),
//       subtitle: Text(blog.subtitle),
//       trailing: Row(
//         main
//       )
//     )
//   )
// }

Widget blogCard(blog, index) {
  return Card(
      child: ListTile(
          title: Text(blog[index].title),
          subtitle:
              Wrap(spacing: 5, direction: Axis.horizontal, children: <Widget>[
            Text('Author :' + blog[index].author),
            Text(blog[index].created_at,
                style: TextStyle(color: Colors.grey[400]))
          ]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          ])));
}

class Home extends StatelessWidget {
  List<BlogModel> blogs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Wrap(
            spacing: 10,
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                'Home',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Welcome, Mario Sandy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Scrollbar(
                child: ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (context, i) => blogCard(blogs, i),
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Create Blog',
        child: const Icon(Icons.add),
      ),
    );
  }
}
