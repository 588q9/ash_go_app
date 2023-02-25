import 'package:ash_go/models/po/message.dart';

class GroupMessageVO extends Message{

  String groupId;


  GroupMessageVO(this.groupId,super.userId, super.messageType, super.createTime);

  @override
  String toString() {
    return 'GroupMessageVO{groupId: $groupId}';
  }
}