import 'package:ash_go/client/isolate_client.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/pages/index_page.dart';
import 'package:ash_go/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AshGOApp());
}

class AshGOApp extends StatefulWidget {
  const AshGOApp({super.key});



 
  
  @override
  State<AshGOApp> createState() {
   return AshGOAppState();
  }
}
class AshGOAppState extends State<AshGOApp>{


 @override
  Widget build(BuildContext context) {
    return UtilContainer(
      child: MaterialApp(
        title: 'AshGO APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const IndexPage(),
      ),
    );
  }
}