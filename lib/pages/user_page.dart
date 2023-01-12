import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            // Provide a standard title.

            bottom: PreferredSize(
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10),
                leading: Container(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://ashone-oss-picture.oss-cn-beijing.aliyuncs.com/myBlog/blog_img/1654333418497.jpg'),
                  ),
                ),
                title: Text(
                  'toto',
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
                subtitle: Text(
                  'toto',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              preferredSize: Size.fromHeight(90),
            ),
            // Allows the user to reveal the app bar if they begin scrolling
            // back up the list of items.
            floating: true,
            // Display a placeholder widget to visualize the shrinking size.

            // Make the initial height of the SliverAppBar larger than normal.
            expandedHeight: 130,
          ),
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildListDelegate([
              ListTile(
                style: ListTileStyle.drawer,
                title: Text(
                  'Info',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              ListTile(
                title: Text('1919810'),
                subtitle: Text('用户号'),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
              ),
              ListTile(
                title: Text('1919810'),
                subtitle: Text('注册日期'),
              ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: Placeholder(
                    strokeWidth: 0,
                    color: Color.fromARGB(243, 243, 243, 255),
                  )),
              Divider(
                height: 20,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
