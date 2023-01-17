import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderBar {
  String name;
  ImageProvider avatar;
  String subTitle;
  HeaderBar(this.name, this.avatar, this.subTitle);
}

class Info {
  String number;
  String subTitle;
  String createTime;
  String subCreateTimeTitle;
  Info(this.number, this.subTitle, this.createTime, this.subCreateTimeTitle);
}

class TabBarAndView {
  ListView tabView;
  String tabName;
  TabBarAndView(this.tabName, this.tabView);
}

class ItemButton {
  Icon? icon;
  String name;
  VoidCallback? onPressed;
  ItemButton(this.name, [this.icon, this.onPressed]);
}

List<PopupMenuItem<int>> _buildMenuList(List<ItemButton> itemButtons) {
  List<PopupMenuItem<int>> menus = [];
  for (int i = 0; i < itemButtons.length; i++) {
    menus.add(PopupMenuItem<int>(
      value: i,
      child: Text(itemButtons[i].name),
    ));
  }
  return menus;
}

class InfoPage extends StatelessWidget {
  HeaderBar headerBar;
  Info info;
  List<ItemButton> itemButtons;
  List<TabBarAndView> tabBarAndViews;
  VoidCallback? toChatPageCallback;
  PopupMenuButton? popupMenuButton;
  InfoPage(
      {super.key,
      required this.headerBar,
      required this.info,
      this.tabBarAndViews = const [],
      this.popupMenuButton,
      this.toChatPageCallback,
      this.itemButtons = const []});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarAndViews.length,
      child: Scaffold(
        body: NestedScrollView(
          body: Container(
            child: TabBarView(
              children: tabBarAndViews.map((e) {
                return e.tabView;
              }).toList(),
            ),
          ),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  PopupMenuButton(
                    onSelected: (value) {
                      itemButtons[value].onPressed?.call();
                    },
                    itemBuilder: (context) {
                      return <PopupMenuEntry<int>>[
                        ..._buildMenuList(itemButtons)
                      ];
                    },
                  )
                ],
                pinned: true,
                // Provide a standard title.

                bottom: PreferredSize(
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 15, bottom: 10),
                    leading: Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(backgroundImage: headerBar.avatar),
                    ),
                    title: Text(
                      headerBar.name,
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                    subtitle: Text(
                      headerBar.subTitle,
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        border: new Border.all(width: 1, color: Colors.white),
                      ),
                      child: IconButton(
                        onPressed: toChatPageCallback,
                        icon: Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                      ),
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
                    title: Text(info.number),
                    subtitle: Text(info.subTitle),
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  ListTile(
                    title: Text(info.createTime),
                    subtitle: Text(info.subCreateTimeTitle),
                  ),
                  const Divider(
                    height: 20,
                  ),
                ]),
              ),
              SliverAppBar(
                toolbarHeight: 38,
                primary: false,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                pinned: true,
                bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 10),
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.black,
                        tabs: tabBarAndViews
                            .map((e) => Tab(
                                  text: e.tabName,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
