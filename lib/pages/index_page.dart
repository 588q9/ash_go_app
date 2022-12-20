import 'package:ash_go/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Column(
                    children: [
                      Image(image: AssetImage("assets/images/logo.png")),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AshGO',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                    ),
                    Text(
                      ' 是一款在线即时聊天App',
                      style: TextStyle(
                        color: Color.fromARGB(255, 77, 74, 74),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {}, child: Text('注册'))),
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
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const LoginPage();
                                  }));
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
