
import 'package:ash_go/models/po/message.dart';
import 'package:json_annotation/json_annotation.dart';
part 'text_message.g.dart';

@JsonSerializable(explicitToJson: true)

class TextMessage extends Message{


  TextMessage(
    super.userId, super.id, super.messageType, super.createTime
    ,this.content,[this.messageId,super.clientId]
  
  );
String? messageId;
String content;

  factory TextMessage.fromJson(Map<String, dynamic> json) => _$TextMessageFromJson(json);
  Map<String, dynamic> toJson() => _$TextMessageToJson(this);  
}