import 'package:ash_go/pages/info_page.dart';
import 'package:flutter/material.dart';

class GroupInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InfoPage(
      itemButtons: [
        ItemButton('删除群聊', null, () {}),
      ],
      headerBar: HeaderBar(
        'toto',
        NetworkImage(
            'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
        'toto',
      ),
      info: Info('1919810', '群号', '1919810', '创建日期'),
      tabBarAndViews: [
        TabBarAndView('群成员', GroupMemeberListView().buildView(context)),
      ],
    );
  }
}

class GroupMemeberListView {
  var groupMemebers = [
    GroupMemeber(),
    GroupMemeber(),
    GroupMemeber(),
    GroupMemeber(),
  ];
  GroupMemeberListView();

  ListView buildView(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return groupMemebers[index];
      },
      separatorBuilder: (context, index) {
        return Divider(
          indent: 60,
        );
      },
      itemCount: groupMemebers.length,
    );
  }
}

class GroupMemeber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
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
                        style: TextStyle(color: Colors.black54, fontSize: 12),
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
    );
  }
}
