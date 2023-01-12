import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.format_list_bulleted),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
// backgroundColor: Theme.of(context).primaryColor
//         ,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'type1',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: DrawerButton(),
      ),
      body: ListView(
        children: ListTile.divideTiles(context: context, tiles: [
          ChatItem(),
          ChatItem(),
          ChatItem(),
        ]).toList(),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(0))),
      onPressed: () {
        Navigator.push(context, ChatPageRoute());
      },
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Container(
          width: 55,
          height: 55,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      'C++中文交流'),
                ),
                Text.rich(TextSpan(
                    style: TextStyle(fontSize: 15.5, color: Colors.grey),
                    children: [
                      TextSpan(
                          style: TextStyle(color: Colors.blueAccent),
                          text: '欧米冈'),
                      TextSpan(text: ':'),
                      TextSpan(text: '啊啊啊啊啊啊')
                    ])),
              ],
            ),
            Column(
              children: [
                Text(style: TextStyle(color: Colors.grey), '15:56'),
                Container(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    '155',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 187, 187, 187),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
