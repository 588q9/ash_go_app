import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('前端技术'),
      ),
      body: ListView(
        reverse: true,
        children: [
          Message(),
          Message(),
          Message(),
          Message(),
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
                  child: RichText(
                      text: TextSpan(
                          children: [TextSpan(text: 'mscdfcmsc')],
                          style: TextStyle(color: Colors.black))),
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
