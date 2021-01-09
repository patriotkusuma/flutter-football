import 'package:flutter/material.dart';
import 'package:sport/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Color(0xFFF9F9F9),
        scaffoldBackgroundColor: Colors.white
      ),
      home: HomeScreen(),
    );
  }
}
