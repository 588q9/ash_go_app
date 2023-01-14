import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [PopupMenuButton(
          onSelected: (value) {
            if(value==1){
            Navigator.push(context, GroupInfoPageRoute());

            }

          },
          itemBuilder: (context){
return [
PopupMenuItem(child: Text('群聊信息'),value: 1,),
PopupMenuItem(child: Text('离开群聊'))


];
        })],
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          textColor: Colors.white,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
          ),
          title: Text('前端技术'),
          subtitle: Row(
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: '111'),
                  TextSpan(text: '个成员，'),
                  TextSpan(text: '100'),
                  TextSpan(text: '人在线'),
                ]),
                style: TextStyle(fontSize: 11, color: Colors.white70),
              )
            ],
          ),
        ),
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
          GestureDetector(
              onTap: () {
                Navigator.push(context, UserPageRoute());
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
              )),
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
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                      Text('2022年12月17日')
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 280, minWidth: 70),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Color.fromARGB(179, 201, 193, 193),
                          width: 0.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            offset: Offset(2, 2))
                      ]),
                  padding: EdgeInsets.all(10),
                  child: Stack(children: [
                    SelectableText.rich(TextSpan(
                        children: [
                          TextSpan(text: 'qqqq凄凄切切群群群群群群群群群群群群群群群群群群群群群群群群群群群'),
                        ],
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                  ]),
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
