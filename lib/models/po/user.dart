
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)

class User {

  static final USER_TABLE="user";

  String id;
  String username;


  String headUrl;



  int userNumber;
int updateTime;

  User(this.username, this.headUrl, this.userNumber,this.id,this.updateTime
    );
    
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);  
}
