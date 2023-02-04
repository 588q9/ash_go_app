
import 'package:ash_go/models/po/message.dart';
import 'package:json_annotation/json_annotation.dart';
part 'text_message.g.dart';

@JsonSerializable(explicitToJson: true)

class TextMessage extends Message{
  static final TEXT_MESSAGE_TABLE="text_message";


  TextMessage(
    super.userId, super.id, super.messageType, super.createTime
    ,this.content,[this.messageId,super.clientId,this.messageClientId]
  
  );
String? messageId;
String content;
int ? messageClientId;
  factory TextMessage.fromJson(Map<String, dynamic> json) => _$TextMessageFromJson(json);
  Map<String, dynamic> toJson() => _$TextMessageToJson(this);  
}