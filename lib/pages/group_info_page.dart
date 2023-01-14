import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupInfoPage extends StatelessWidget {
  var groupMemebers = [
    GroupMemeber(),
    GroupMemeber(),
    GroupMemeber(),
    GroupMemeber(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return groupMemebers[index];
        },
        separatorBuilder: (context, index) {
          return Divider(
            indent: 60,
          );
        },
        itemCount: groupMemebers.length,
      ),
    ));
  }
}

class GroupMemeber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'aksop1',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '在线',
                        style: TextStyle(color: Colors.black54, fontSize: 10),
                      )
                    ],
                  ),
                  Text(
                    '管理员',
                    style: TextStyle(color: Colors.lightBlue, fontSize: 12),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    )

        // ListTile(

        //   leading: CircleAvatar(
        //     backgroundImage: NetworkImage(
        //         'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
        //   ),
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text('aksop1'),
        //       Text(
        //         '管理员',
        //         style: TextStyle(color: Colors.lightBlue, fontSize: 12),
        //       )
        //     ],
        //   ),
        //   subtitle: Text('在线'),
        // )
        ;
  }
}
