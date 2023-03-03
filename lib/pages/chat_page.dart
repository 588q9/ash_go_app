import 'package:ash_go/common/enums/message_status.dart';
import 'package:ash_go/common/util/date_util.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/pages/overview_page.dart';
import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';

import '../models/po/message.dart';
import '../models/vo/contact_message_vo.dart';
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
ChatBottomBar chatBottomBar;

  ChatPage({required this.chatTitleInfo,required this.bottomBarSpan,required this.popupMenuButton

  ,required this.messageDigrams,
    required this.chatBottomBar
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
      body: ChatBody(list: messageDigrams,chatBottomBar: chatBottomBar,),
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
ChatBottomBar chatBottomBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: MessageView(list: list,)), chatBottomBar],
    );
  }

  ChatBody({required this.list,required this.chatBottomBar});


}
abstract class ChatBottomBarState<T extends ChatBottomBar> extends State<T>{

  final textMessageController = TextEditingController();
bool canSendMessage=false;
List<Widget> rightOtherButton=[];
VoidCallback sendMessageCallback=(){};
  @override
  void initState() {
    super.initState();
    textMessageController.addListener(() {
      String textContent=textMessageController.text;
      setState(() {
        canSendMessage=textContent.isNotEmpty;
      });
    });
  }



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
              textInputAction: TextInputAction.send,
              controller: textMessageController,
              maxLines: null,
              decoration: InputDecoration(hintText: '发送消息'),
            ),
          ),

          ...(canSendMessage?[

            Expanded(flex: 1, child: IconButton( onPressed: sendMessageCallback, icon:Icon(Icons.send) ,))

          ]:rightOtherButton)

        ],
      ),
    );
  }
}
abstract class ChatBottomBar extends StatefulWidget {
  const ChatBottomBar({super.key});





}


abstract class MessageDiagram extends StatelessWidget {
final Message message;
final bool isMySent;
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment:!isMySent?CrossAxisAlignment.start:CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [

                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            message.sendUserVO?.username!=null&&!isMySent?message.sendUserVO!.username!:'',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                      Text(datestampToFormat('yyyy年MM月dd日 h:m', message.createTime) )
                    ],
                  ),
                ),


                Row(
                  children: [

                  isMySent?statusIndicator(message.messageStatus):
                  const SizedBox(

                    child: null,
                  )
                  ,
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      constraints: const BoxConstraints(maxWidth: 280, minWidth: 70),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Color.fromARGB(179, 201, 193, 193),
                              width: 0.5,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                offset: Offset(2, 2))
                          ]),
                      padding: const EdgeInsets.all(10),
                      child: Stack(children: [
                        SelectableText.rich(TextSpan(
                            children: [
                              TextSpan(text: message.textContent),
                            ],
                            style: const TextStyle(
                              color: Colors.black,
                            ))),
                      ]),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget statusIndicator(int? status){

    var child;
if(status==MessageStatus.FAIL_SEND.index){
   child= const Icon(Icons.error,color: Colors.red);
}
else if(status==MessageStatus.SENDING.index){
  child= CircularProgressIndicator(
    backgroundColor: Colors.grey[200],
    valueColor: const AlwaysStoppedAnimation(Colors.blue),
  );
}
return   SizedBox(
  width: 20,
  height: 20,
  child: child,
);
}



}
