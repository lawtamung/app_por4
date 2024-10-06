import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SoilMoistureScreen extends StatefulWidget {
  const SoilMoistureScreen({super.key});

  @override
  _SoilMoistureScreenState createState() => _SoilMoistureScreenState();
}

class _SoilMoistureScreenState extends State<SoilMoistureScreen> {
  String soilMoisture = 'กำลังโหลดข้อมูล...';

  Future<void> fetchSoilMoisture() async {
    // เรียก API จาก ESP32 เพื่อดึงข้อมูลความชื้นดิน
    final response = await http.get(Uri.parse('http://<ESP32_IP>/soil-moisture'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        soilMoisture = 'ความชื้นดิน: ${data['moisture']}%';
      });
    } else {
      setState(() {
        soilMoisture = 'ไม่สามารถโหลดข้อมูลความชื้นดินได้';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSoilMoisture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เช็คความชื้นดิน')),
      body: Center(
        child: Text(soilMoisture),
      ),
    );
  }
}
