import 'package:flutter/material.dart';
import 'water_pump_screen.dart';  // ลิงก์ไปหน้าเปิดปิดปั๊มน้ำ
import 'weather_screen.dart';    // ลิงก์ไปหน้าเช็คสภาพอากาศ
import 'growth_screen.dart';     // ลิงก์ไปหน้าสำรวจการเจริญเติบโต
import 'soil_moisture_screen.dart'; // ลิงก์ไปหน้าเช็คความชื้นดิน
import 'login_screen.dart'; // ลิงก์ไปหน้า Login

class HomeScreen extends StatelessWidget {
  final String username; // ตัวแปรสำหรับชื่อผู้ใช้
  final String userId;   // ตัวแปรสำหรับ userId

  HomeScreen({required this.username, required this.userId}); // รับ username และ userId ใน constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Rain Grow', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: Container(
        color: Colors.lightBlue[50], // พื้นหลังสีฟ้าอ่อน
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('ยินดีต้อนรับ, $username!', // แสดงชื่อผู้ใช้
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              _buildMenuButton(context, 'รดน้ำต้นไม้', WaterPumpScreen()),
              _buildMenuButton(context, 'เช็คสภาพอากาศ', WeatherScreen()),
              _buildMenuButton(context, 'สำรวจการเจริญเติบโต', GrowthScreen(userId: userId)), // ส่ง userId ที่ถูกต้อง
              _buildMenuButton(context, 'เช็คความชื้นดิน', SoilMoistureScreen()),
              SizedBox(height: 20), // เพิ่มช่องว่าง
              _buildLogoutButton(context), // ปุ่มล็อคเอาท์
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent], // ไล่สีฟ้า
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // เงาเบา ๆ รอบปุ่ม
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {
          // นำผู้ใช้กลับไปที่หน้า Login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red, // เปลี่ยนสีพื้นหลังเป็นสีแดง
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'ล็อคเอาท์', // ข้อความในปุ่มล็อคเอาท์
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
