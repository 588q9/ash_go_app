import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';

import 'overview_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Text(
                  '立刻登录以进行使用！',
                  textScaleFactor: 2,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 30),
                  child: Text(
                    style: TextStyle(color: Colors.grey),
                    '很高兴你能使用AshGO!',
                    textScaleFactor: 1.3,
                  ),
                ),
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '电子邮箱地址或账号或电话号码',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: TextFormField(
                          decoration: const InputDecoration(
                        hintText: '密码',
                      )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Text(
                        '忘记密码',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('敬请期待')));
                      },
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                       Navigator.pushAndRemoveUntil(context, OverviewRoute(), (route) => false);
                        

                        },
                        child: Text('登录'),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
