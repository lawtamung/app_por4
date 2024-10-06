import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart'; // ลิงก์ไปยังหน้า Home
import 'register_screen.dart'; // ลิงก์ไปยังหน้า Register

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    final response = await http.post(
      Uri.parse("http://10.96.3.236/apipro4/login.php"),
      body: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );

    var data = jsonDecode(response.body);
    if (data['success']) {
      // ส่งชื่อผู้ใช้และ userId ที่ได้จาก API ไปยัง HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: data['username'], // ส่งชื่อผู้ใช้ที่แท้จริง
            userId: data['user_id'].toString(), // แปลง user_id เป็น String
          ),
        ),
      );
    } else {
      setState(() {
        errorMessage = data['message']; // แสดงข้อความผิดพลาดจาก API
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // สีพื้นหลัง
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        backgroundColor: Colors.lightBlueAccent, // สีพื้นหลังของ AppBar
        elevation: 0, // ไม่มีเงาใต้ AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // ขยายปุ่มให้เต็มความกว้าง
          children: [
            // โลโก้หรือไอคอนด้านบน
            const Icon(
              Icons.lock_outline,
              size: 100,
              color: Colors.lightBlueAccent,
            ),
            const SizedBox(height: 40),

            // ช่องกรอกอีเมล
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'อีเมล',
                labelStyle: const TextStyle(color: Colors.lightBlueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ช่องกรอกรหัสผ่าน
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                labelStyle: const TextStyle(color: Colors.lightBlueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // แสดงข้อความผิดพลาด (ถ้ามี)
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            // ปุ่มล็อกอิน
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),

            // ปุ่มไปหน้า Register
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()), // ลิงก์ไปหน้า Register
                );
              },
              child: const Text(
                'ยังไม่มีแอคเคาท์ใช่ไหม? คลิกเพื่อสมัคร',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
