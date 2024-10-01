import 'package:flutter/material.dart';
import 'package:qr_code_reader/screens/qr_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF060E38),
      ),
      color: Colors.black,
      home: QrScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
