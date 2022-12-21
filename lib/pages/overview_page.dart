import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AshGO'),
      ),
      body: ListView(
        children: [
          ChatItem(),
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {

        Navigator.push(context, ChatPageRoute());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('wqeqw'), Text('wqeqw')],
          ),

          trailing: Text(
            '15:56'
          ),
        ),
      ),
    );
  }
}
