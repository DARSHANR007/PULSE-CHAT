import 'package:chat_bot/home_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(useMaterial3: true)
    );
  }
}

