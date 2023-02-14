

abstract class Message{
  static final MESSAGE_TABLE="message";
String? id;
int messageType;
int createTime;

int? clientId;
int? isSend;
int userId;
 String? textContent;
 String? extentionFile;
Message(this.userId,this.id,this.messageType,

this.createTime,[this.isSend,this.clientId,this.textContent,this.extentionFile]);


}