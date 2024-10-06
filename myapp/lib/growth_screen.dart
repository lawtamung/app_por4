import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ManageDataScreen.dart'; // อย่าลืมนำเข้า ManageDataScreen

class GrowthScreen extends StatefulWidget {
  final String userId;

  const GrowthScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _GrowthScreenState createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  final TextEditingController heightController = TextEditingController();
  DateTime? selectedDate;
  List<GrowthData> growthData = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addGrowthData() async {
    if (selectedDate != null && heightController.text.isNotEmpty) {
      final String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
      final double height = double.parse(heightController.text);

      final response = await http.post(
        Uri.parse('http://10.96.3.236/apipro4/grow.php'),
        body: {
          'user_id': widget.userId,
          'date': formattedDate,
          'height': height.toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
        );
        fetchGrowthData();
        heightController.clear();
        selectedDate = null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาด')),
        );
      }
    }
  }

  Future<void> fetchGrowthData() async {
    final response = await http.get(
      Uri.parse('http://10.96.3.236/apipro4/grow.php?user_id=${widget.userId}'),
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      
      try {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          growthData = data.map((item) {
            final DateTime date = DateFormat('dd/MM/yyyy').parse(item['date']);
            return GrowthData(date, double.parse(item['height'].toString()));
          }).toList();
          growthData.sort((a, b) => a.date.compareTo(b.date));
        });
      } catch (e) {
        print('Error parsing JSON: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถแปลงข้อมูลได้: $e')),
        );
      }
    } else {
      print('Error fetching data: ${response.statusCode}');
      throw Exception('ไม่สามารถดึงข้อมูลได้');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGrowthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บันทึกและแสดงผลการเจริญเติบโต'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchGrowthData, // ทำให้ปุ่มรีเฟรชเรียกใช้ fetchGrowthData
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlue[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDatePicker(),
            const SizedBox(height: 10),
            _buildHeightInput(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
            const SizedBox(height: 20),
            _buildChart(),
            const SizedBox(height: 20),
            _buildManageDataButton(), // เพิ่มปุ่มจัดการข้อมูลที่นี่
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: selectedDate == null
            ? 'เลือกวันที่'
            : 'วันที่: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildHeightInput() {
    return TextField(
      controller: heightController,
      decoration: const InputDecoration(
        labelText: 'ความสูงของต้นไม้ (ซม.)',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: addGrowthData,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(
        'บันทึกข้อมูล',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildManageDataButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageDataScreen(userId: widget.userId),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(
        'จัดการข้อมูล',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildChart() {
    return Expanded(
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('dd/MM/yyyy'),
          interval: 1,
        ),
        title: ChartTitle(text: 'การเจริญเติบโตของต้นไม้ในแต่ละวัน'),
        series: <ChartSeries>[
          LineSeries<GrowthData, DateTime>(
            dataSource: growthData,
            xValueMapper: (GrowthData data, _) => data.date,
            yValueMapper: (GrowthData data, _) => data.height,
            name: 'ความสูงของต้นไม้',
            color: Colors.lightBlue,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
        plotAreaBackgroundColor: Colors.white,
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
        ),
      ),
    );
  }
}

class GrowthData {
  GrowthData(this.date, this.height);

  final DateTime date;
  final double height;
}
