import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WaterPumpScreen extends StatefulWidget {
  const WaterPumpScreen({super.key});

  @override
  _WaterPumpScreenState createState() => _WaterPumpScreenState();
}

class _WaterPumpScreenState extends State<WaterPumpScreen> {
  bool isPumpOn = false;

  Future<void> togglePump() async {
    // ส่งคำสั่งไปยัง ESP32 เพื่อเปิดหรือปิดปั๊มน้ำ
    final response = await http.get(Uri.parse('http://<ESP32_IP>/pump?status=${isPumpOn ? 'off' : 'on'}'));
    
    if (response.statusCode == 200) {
      setState(() {
        isPumpOn = !isPumpOn;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ไม่สามารถสั่งงานปั๊มน้ำได้')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ควบคุมปั๊มน้ำ'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center( // แก้ให้คอนเทนต์อยู่ตรงกลาง
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded( // ใช้ Expanded เพื่อให้ไอคอนขยายให้เต็มพื้นที่ตรงกลาง
                child: Icon(
                  isPumpOn ? Icons.water_drop : Icons.water_damage,
                  size: 150, // ปรับขนาดไอคอนใหญ่ขึ้น
                  color: isPumpOn ? Colors.blue : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isPumpOn ? 'ปั๊มน้ำกำลังทำงาน' : 'ปั๊มน้ำปิดอยู่',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPumpOn ? Colors.blue : Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: togglePump,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPumpOn ? Colors.redAccent : Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  isPumpOn ? 'ปิดปั๊มน้ำ' : 'เปิดปั๊มน้ำ',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
