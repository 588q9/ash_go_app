import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('前端技术'),
      ),
      body: _ChatBody(),
    );
  }
}

Iterable<Widget> _messageList() {
  List<Widget> list = [];
  for (int i = 0; i < 100; i++) {
    list.add(Message());
  }
  return list;
}

class _MessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      children: [..._messageList().toList()],
    );
  }
}

class _ChatBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: _MessageView()), ChatBottomBar()],
    );
  }
}

class ChatBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          Expanded(
            child: Icon(Icons.emoji_emotions),
            flex: 1,
          ),
          Expanded(
            flex: 8,
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(hintText: '发送消息'),
            ),
          ),
          Expanded(child: Icon(Icons.attach_file), flex: 1),
          Expanded(child: Icon(Icons.phone), flex: 1)
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            '8848',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          )),
                      Text('2022年12月17日')
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: SelectableText.rich(TextSpan(children: [
                    TextSpan(text: 'mscdfcmsc mscdfcmscmscdfcmscmscdfcmsc'),
                  ], style: TextStyle(color: Colors.black))),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }
}
