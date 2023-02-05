import 'package:ash_go/common/protocol/frame/client/user/user_info_client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_register_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_info_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_login_server_frame.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/login_token.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
return RegisterPageState();
  }

}


class RegisterPageState extends State<RegisterPage>{

    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  return Scaffold(

    appBar: AppBar(),
    body:SafeArea(
      child: ListView(
          padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
    children:  [
       SizedBox(height: 120),
    _UsernameTextField(_usernameController),
    _PasswordTextField(_passwordController),
    ElevatedButton(
child: Text('注册'),
onPressed: (){
var username=this._usernameController.text;
var password=this._passwordController.text;
var frame=UserRegisterClientFrame(username,password);
var utilContainer=UtilContainer.of(context);
utilContainer!.client.send(frame).then((value) async{

if(value is UserLoginServerFrame){
var userInfoServerFrame=await  utilContainer.client.send(UserInfoClientFrame()) as UserInfoServerFrame;
print(userInfoServerFrame.toJson());
  var mapper=await utilContainer.mapper;

await mapper.delete(LoginToken.LOGIN_TOKEN_TABLE,where: 'userId=?',whereArgs: [userInfoServerFrame.user.id]);



await mapper.insert(LoginToken.LOGIN_TOKEN_TABLE, value.toJson());
await mapper.delete(User.USER_TABLE,where: 'id=?',whereArgs: [userInfoServerFrame.user.id]);
await mapper.insert(User.USER_TABLE, {
  'id':userInfoServerFrame.user.id,
  'username':userInfoServerFrame.user.username,
  'headUrl':userInfoServerFrame.user.headUrl
  ,'userNumber':userInfoServerFrame.user.userNumber,

});
await mapper.delete('users_contacts',where: 'sentUserId=?',whereArgs: [userInfoServerFrame.user.id]);
userInfoServerFrame.user.contacts.forEach((element) {
 mapper.insert('users_contacts', {
  'sentUserId':userInfoServerFrame.user.id,
  'receiveUserId':element.id,
  'createTime':null
});

 });
Navigator.pushReplacement(context, OverviewRoute());


}

});


},
    )
    ],
    
    
      ),
    )
  
  ,);
  }



}
class _UsernameTextField extends StatelessWidget {
    final userMetaController ;

   _UsernameTextField(this.userMetaController);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: userMetaController,
      
      textInputAction: TextInputAction.next,
      restorationId: 'username_text_field',
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        labelText: '用户名',
      
      ),
    );
  }
}


class _PasswordTextField extends StatelessWidget {
    final userMetaController ;

   _PasswordTextField(this.userMetaController);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: userMetaController,
      textInputAction: TextInputAction.next,
      restorationId: 'password_text_field',
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        labelText: '密码',
      
      ),
    );
  }
}