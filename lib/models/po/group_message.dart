// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'group_message.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupMessage {
  static final MESSAGE_TABLE="group_message";
String? groupId;
String ? messageId;
int? messageClientId;
  GroupMessage({
    this.groupId,
    this.messageId,
    this.messageClientId,
  });




  @override
  String toString() => 'GroupMessage(groupId: $groupId, messageId: $messageId, messageClientId: $messageClientId)';
}
