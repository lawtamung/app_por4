import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String weatherInfo = 'กำลังโหลดข้อมูล...';
  String location = 'กรุงเทพมหานคร'; // ค่าตั้งต้นสำหรับตำแหน่ง
  bool isLoading = true;

  final TextEditingController locationController = TextEditingController();

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true; // ตั้งค่าให้โหลดใหม่
    });

    try {
      final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$location&appid=d57c437ce22c82b641462ddb173e6da4&units=metric'));
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          weatherInfo = 'อุณหภูมิ: ${data['main']['temp']}°C\nมีแนวโน้มฝนตก: ${data['weather'][0]['description']}';
          isLoading = false;
        });
      } else {
        setState(() {
          weatherInfo = 'ไม่สามารถโหลดข้อมูลสภาพอากาศได้';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        weatherInfo = 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สภาพอากาศ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'กรุณากรอกชื่อเมือง',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      location = locationController.text.isNotEmpty ? locationController.text : 'กรุงเทพมหานคร'; // ใช้ชื่อเมืองจากผู้ใช้
                      fetchWeather();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue, // เปลี่ยนจาก primary เป็น backgroundColor
                  ),
                  child: const Text('ดูสภาพอากาศ'),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                location, // แสดงตำแหน่ง
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                weatherInfo,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
