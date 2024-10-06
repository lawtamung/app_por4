import 'package:flutter/material.dart';
import 'login_screen.dart'; // นำเข้าหน้า Login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // กำหนดหน้าแรกเป็น LoginScreen
      debugShowCheckedModeBanner: false, // ปิดแสดง banner debug
    );
  }
}
