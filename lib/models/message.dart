abstract class Message{
int id;
int messageType;
int createTime;
int? readTime;
Message(this.id,this.messageType,this.createTime,[this.readTime]);


}