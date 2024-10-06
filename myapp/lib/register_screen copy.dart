import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController(); // คอนโทรลเลอร์สำหรับชื่อผู้ใช้
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> signup() async {
    if (usernameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    final response = await http.post(
      Uri.parse("http://192.168.148.87/apipro4/signup.php"),
      body: {
        "username": usernameController.text, // ส่งชื่อผู้ใช้ไปยัง API
        "email": emailController.text,
        "password": passwordController.text,
      },
    );

    var data = jsonDecode(response.body);
    if (data['success']) {
      Navigator.pop(context); // กลับไปหน้า Login หลังสมัครสำเร็จ
    } else {
      setState(() {
        errorMessage = data['message']; // แสดงข้อความผิดพลาดจาก API
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('สร้างบัญชี'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // โลโก้หรือไอคอนด้านบน
            const Icon(
              Icons.person_add,
              size: 100,
              color: Colors.lightBlueAccent,
            ),
            const SizedBox(height: 40),

            // ช่องกรอกชื่อผู้ใช้
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'ชื่อผู้ใช้',
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

            // ปุ่มสมัครสมาชิก
            ElevatedButton(
              onPressed: signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('สมัคร', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
