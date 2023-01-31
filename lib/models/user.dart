class User {
  String id;
  String username;
  String password;

  String headUrl;

  String? email;

  String? phone;

  int userNumber;


  User(this.username, this.headUrl, this.userNumber,this.id,this.password,
      [ this.email, this.phone]);
}
