import 'package:ash_go/common/database/mapper.dart';
import 'package:ash_go/common/database/sqlite_test.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/pages/login_page.dart';
import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        'AshGO',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Theme.of(context).backgroundColor),
                      ),
                      Image(image: AssetImage("assets/images/logo.png")),
                    ],
                  ),
                ),
                const Text.rich(
                  TextSpan(children: [

                    TextSpan(
                      text: ' 在线即时聊天App',
                      style: TextStyle(
                        color: Color.fromARGB(255, 77, 74, 74),
                        fontSize: 20,
                      ),
                    ),
                  ]),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                  Navigator.push(context, RegisterPageRoute());
            
                                  },
                                  child: Text('注册'))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {}, child: Text('快速登录'))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.grey)),
                                onPressed: () {
                                  Navigator.push(context, LoginRoute());
                                },
                                child: Text('登录')),
                          ),
                        ],
                      ),
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
