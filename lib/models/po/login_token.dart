
import 'package:json_annotation/json_annotation.dart';

part 'login_token.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginToken{
  static final LOGIN_TOKEN_TABLE="login_token";

String ?userId;

String token;
LoginToken(this.token,[this.userId]);

  factory LoginToken.fromJson(Map<String, dynamic> json) => _$LoginTokenFromJson(json);
  Map<String, dynamic> toJson() => _$LoginTokenToJson(this);  

}