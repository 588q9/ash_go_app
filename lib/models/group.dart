class Group {
  int id;
  String groupName;
  int groupNumber;
  DateTime? createTime;
  String? descriptions;
String? notice;
  String? headUrl;
  Group(this.id, this.groupName, this.groupNumber,
      [this.createTime, this.descriptions, this.headUrl,this.notice]);
}
