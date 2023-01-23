abstract class Message{
int id;
bool type;
DateTime? storageTime;
DateTime? readTime;
Message(this.id,this.type,[this.storageTime,this.readTime]);


}