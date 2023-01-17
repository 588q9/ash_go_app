import 'package:ash_go/pages/info_page.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoPage(
      headerBar: HeaderBar(
        'toto',
        NetworkImage(
            'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
        'toto',
      ),
      info: Info('1919810', '用户号', '1919810', '注册日期'),
      tabBarAndViews: [
        TabBarAndView('相关群聊', ListView()),
        TabBarAndView('共同联系人', ListView()),
        TabBarAndView('media', ListView()),
      ],
    );
  }
}
