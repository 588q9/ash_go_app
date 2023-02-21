import 'package:ash_go/common/protocol/frame/client/user/user_info_client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_register_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_info_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_login_server_frame.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/login_token.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/pages/login_page.dart';
import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController(text: null);
  final _passwordController = TextEditingController(text: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          children: [
            SizedBox(height: 120),
            _UsernameTextField(_usernameController),
            _PasswordTextField(_passwordController),
            ElevatedButton(
              child: Text('注册'),
              onPressed: () {
                var username = this._usernameController.text;
                var password = this._passwordController.text;
                var frame = UserRegisterClientFrame(username, password);

                loginOrRegisterLogic(frame, context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  final userMetaController;

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
  final userMetaController;

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
