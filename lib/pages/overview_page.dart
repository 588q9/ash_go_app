import 'package:ash_go/common/protocol/frame/client/user/user_info_client_frame.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/contact_message.dart';
import 'package:ash_go/models/po/message.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/models/po/user_contacts.dart';
import 'package:ash_go/models/vo/contact_message_vo.dart';
import 'package:ash_go/models/vo/user_contact_vo.dart';
import 'package:ash_go/models/vo/user_vo.dart';
import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../common/util/date_util.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.format_list_bulleted),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

class OverviewPage extends StatefulWidget {

  const OverviewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return OverviewPageState();
  }
}


const String  DEFAULT_HEAD_URL="https://gitee.com/assets/no_portrait.png";


class OverviewPageState extends State<OverviewPage> {
  UserVO userInfo=UserVO();
List<ChatItem> chatBriefList=[];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UtilContainer? container=UtilContainer.of(context);
    container!.client.send(UserInfoClientFrame()).then((value) {
      setState(() {
        userInfo = value.user;
        UtilContainer.of(context)!.mapper.then((value) {
          value.insert(User.USER_TABLE, userInfo.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);

        });
      });
    }).then((val) {
      container.mapper.then((db) async{

        var users=(await db.rawQuery("select * from user_contacts a inner join user b on a.userId=b.id;")).map((e) => User.fromJson(e));

        for(var item in users){
          ContactMessageVO? contactMessageWrap;
          SimpleMessage? simpleMessage;
          var contactMessage=(await db.rawQuery('select * from contact_message a inner  join message b on a.messageClientId=b.id  where  b.userId=? or( b.userId=? and a.receiveUserId=?) order by createTime desc limit 1',[item.id
            ,await container.userId,item.id
          ]));
          if(contactMessage.isNotEmpty){
            contactMessageWrap=ContactMessageVO.fromJson(contactMessage[0]);


            contactMessageWrap.sendUserVO??=UserVO.fromJson((await db.query(User.USER_TABLE,where: "id=?",whereArgs: [contactMessageWrap.userId]))[0]);

            simpleMessage=SimpleMessage(contactMessageWrap.sendUserVO!.username!,contactMessageWrap.receiveUserId ,
                contactMessageWrap.messageType, contactMessageWrap.createTime,
                contactMessageWrap.id,contactMessageWrap.messageStatus,contactMessageWrap.clientId,contactMessageWrap.textContent
                ,contactMessageWrap.extensionContent
            );

          }

          ChatItem chatItem=ChatItem(item.id, false, item.headUrl, item.username, simpleMessage, 0);


          chatBriefList.add(chatItem);
        }


      }).then((value) {
        setState(() {});
      });
    });




  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
                      backgroundImage: NetworkImage(userInfo.headUrl ??
                          DEFAULT_HEAD_URL),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      userInfo.username ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
        children: ListTile.divideTiles(context: context, tiles:
        chatBriefList.map((e){
          return ChatDigram(e);
        })
        ).toList(),
      ),
    );
  }
}
class SimpleMessage extends Message{
  String username;

  SimpleMessage(this.username,super.userId,super.messageType,super.createTime,super.id,super.isSend,super.clientId,super.textContent,super.extensionContent
      ) ;


}



class  ChatItem{
String id;
bool isGroup=false;
String headUrl;
String name;
SimpleMessage? latestMessage;
int unReadCount;
ChatItem(this.id, this.isGroup, this.headUrl, this.name, this.latestMessage,this.unReadCount);

@override
  String toString() {
    return 'ChatItem{id: $id, isGroup: $isGroup, headUrl: $headUrl, name: $name, latestMessage: $latestMessage, unReadCount: $unReadCount}';
  }
}





class ChatDigram extends StatelessWidget {
  ChatItem chatItem;

  ChatDigram(this.chatItem);

  Widget build(BuildContext context) {


    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(0))),
      onPressed: () {

        Navigator.push(context, ChatPageRoute(chatItem));
      },
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Container(
          width: 50,
          height: 50,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                chatItem.headUrl
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                      style:
                      const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      chatItem.name),
                ),
                Text.rich(TextSpan(
                    style: const TextStyle(fontSize: 15.5, color: Colors.grey),
                    children: chatItem.latestMessage!=null? [
                      TextSpan(
                          style: const TextStyle(color: Colors.blueAccent),
                          text: chatItem.latestMessage?.username),
                       const TextSpan(text: ':'),
                      TextSpan(text: chatItem.latestMessage?.textContent)
                    ]:[]

                )),
              ],
            ),

            Column(
              children: [
                Text(
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                 chatItem.latestMessage!=null?
                  datestampToFormat('yy-M-d H:m',chatItem.latestMessage!.createTime):''
                   ,
                ),
                chatItem.unReadCount>0?ChatUnReadTip(count: chatItem.unReadCount)
                    :const SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }

}

class ChatUnReadTip extends StatelessWidget{
int count;

ChatUnReadTip({ required this.count});

@override
  Widget build(BuildContext context) {
   return Container(
      padding: EdgeInsets.all(4),
      child:  Text(
        count.toString(),
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 187, 187, 187),
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}

