

abstract class Message{
  static final MESSAGE_TABLE="message";
String? id;
int messageType;
int createTime;

int? clientId;
int? isSend;
int userId;
Message(this.userId,this.id,this.messageType,

this.createTime,[this.isSend,this.clientId]);


}