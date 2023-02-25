import 'package:ash_go/common/util/date_util.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/pages/overview_page.dart';
import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';

import '../models/po/message.dart';
abstract class ChatTitleInfo{
  String headUrl;
  String name;
String id;
  String? status;

  ChatTitleInfo({required this.headUrl,required this.name,required this.id, this.status});
}




class ChatTitle extends StatelessWidget{

 ChatTitleInfo chatTitleInfo;
 List<InlineSpan> bottomSpan=[];
ChatTitle({ required this.chatTitleInfo,required  this.bottomSpan});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      textColor: Colors.white,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
           chatTitleInfo.headUrl ),
      ),
      title: Text(chatTitleInfo.name),
      subtitle: Row(
        children: [
          Text.rich(
            TextSpan(children:
            bottomSpan
            ),
            style: TextStyle(fontSize: 11, color: Colors.white70),
          )
        ],
      ),
    );
  }




}




class ChatPage extends StatelessWidget {
  ChatTitleInfo chatTitleInfo;
  List<InlineSpan> bottomBarSpan;
  PopupMenuButton<int> popupMenuButton;
List<MessageDiagram> messageDigrams;


  ChatPage({required this.chatTitleInfo,required this.bottomBarSpan,required this.popupMenuButton

  ,required this.messageDigrams
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
       popupMenuButton
        ],
        title:ChatTitle(chatTitleInfo: chatTitleInfo,bottomSpan: bottomBarSpan,) ,
      ),
      body: ChatBody(list: messageDigrams,),
    );
  }







}
//
// Iterable<Widget> _messageList() {
//   List<Widget> list = [];
//   for (int i = 0; i < 100; i++) {
//     list.add(MessageDiagram());
//   }
//   return list;
// }

class MessageView extends StatelessWidget {

  List<MessageDiagram> list;

  MessageView({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      children: list,
    );
  }
}

class ChatBody extends StatelessWidget {
  List<MessageDiagram> list;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: MessageView(list: list,)), ChatBottomBar()],
    );
  }

  ChatBody({required this.list});


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


abstract class MessageDiagram extends StatelessWidget {
Message message;
bool isMySent;
MessageDiagram({required this.message,this.isMySent=false });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        textDirection: isMySent?TextDirection.rtl:TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(context, UserInfoPageRoute());
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    message.sendUserVO?.headUrl??DEFAULT_HEAD_URL),
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
                            message.sendUserVO?.username!=null&&!isMySent?message.sendUserVO!.username!:'',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                      Text(datestampToFormat('yyyy年MM月dd日 h:m', message.createTime) )
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
                          TextSpan(text: message.textContent),
                        ],
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                  ]),
                )
              ],
              crossAxisAlignment:!isMySent?CrossAxisAlignment.start:CrossAxisAlignment.end,
            ),
          )
        ],
      ),
    );
  }
}
