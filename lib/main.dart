import 'package:ash_go/pages/index_page.dart';
import 'package:ash_go/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AshGOApp());
}

class AshGOApp extends StatelessWidget {
  const AshGOApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const IndexPage(),
    );
  }
}
