// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'contact_message.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactMessage {
  static final MESSAGE_TABLE="contact_message";

String? messageId;
String? receiveUserId;
int? messageClientId;
  ContactMessage({
    this.messageId,
    this.receiveUserId,
    this.messageClientId,
  });



  @override
  String toString() => 'ContactMessage(messageId: $messageId, receiveUserId: $receiveUserId, messageClientId: $messageClientId)';
}
