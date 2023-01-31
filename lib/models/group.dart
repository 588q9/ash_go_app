class Group {
  int id;
  String groupName;
  int groupNumber;
  int createTime;
  String? descriptions;
String? notice;
  String headUrl;
  Group(this.id, this.groupName, this.groupNumber,this.headUrl,this.createTime,
      [ this.descriptions, this.notice]);
}
