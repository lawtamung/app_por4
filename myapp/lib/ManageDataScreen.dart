import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // นำเข้า intl

class ManageDataScreen extends StatefulWidget {
  final String userId;

  const ManageDataScreen({super.key, required this.userId});

  @override
  _ManageDataScreenState createState() => _ManageDataScreenState();
}

class _ManageDataScreenState extends State<ManageDataScreen> {
  List<GrowthData> growthData = [];
  final TextEditingController heightController = TextEditingController();
  DateTime? selectedDate;
  int? selectedId; // ใช้เก็บ ID ของข้อมูลที่ต้องการแก้ไข

  @override
  void initState() {
    super.initState();
    fetchGrowthData();
  }

  Future<void> fetchGrowthData() async {
    final response = await http.get(
      Uri.parse('http://10.96.3.236/apipro4/grow.php?user_id=${widget.userId}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        growthData = data.map((item) {
          return GrowthData(item['id'], item['date'], double.parse(item['height'].toString()));
        }).toList();
      });
    } else {
      print('Error fetching data: ${response.statusCode}');
    }
  }

  void addGrowthData() async {
    if (selectedDate != null && heightController.text.isNotEmpty) {
      final String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
      final double height = double.parse(heightController.text);

      if (selectedId != null) {
        // ถ้าต้องการอัปเดตข้อมูล
        await updateGrowthData(selectedId!, height);
      } else {
        // ถ้าต้องการเพิ่มข้อมูลใหม่
        final response = await http.post(
          Uri.parse('http://10.96.3.236/apipro4/grow.php'),
          body: {
            'user_id': widget.userId,
            'date': formattedDate,
            'height': height.toString(),
          },
        );

        if (response.statusCode == 200) {
          fetchGrowthData();
          heightController.clear();
          selectedDate = null;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving data')));
        }
      }
    }
  }

  Future<void> updateGrowthData(int id, double height) async {
    final response = await http.put(
      Uri.parse('http://10.96.3.236/apipro4/grow.php'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        'id': id.toString(),
        'height': height.toString(),
        'user_id': widget.userId
      },
    );

    if (response.statusCode == 200) {
      fetchGrowthData();
      heightController.clear();
      selectedDate = null;
      selectedId = null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data updated successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating data')));
    }
  }

  Future<void> deleteGrowthData(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.96.3.236/apipro4/grow.php'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        'id': id.toString(),
        'user_id': widget.userId
      },
    );

    if (response.statusCode == 200) {
      fetchGrowthData();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting data')));
    }
  }

  Widget _buildGrowthList() {
    return ListView.builder(
      itemCount: growthData.length,
      itemBuilder: (context, index) {
        final data = growthData[index];
        return ListTile(
          title: Text('Date: ${data.date}, Height: ${data.height} cm'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit), // ปุ่มแก้ไข
                onPressed: () {
                  setState(() {
                    selectedId = data.id;
                    selectedDate = DateFormat('dd/MM/yyyy').parse(data.date);
                    heightController.text = data.height.toString();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete), // ปุ่มลบ
                onPressed: () {
                  deleteGrowthData(data.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Growth Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addGrowthData(); // จะเพิ่มหรืออัปเดตข้อมูลตาม context
              },
              child: Text(selectedId != null ? 'Update Data' : 'Add Data'),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildGrowthList()),
          ],
        ),
      ),
    );
  }
}

class GrowthData {
  final int id;
  final String date;
  final double height;

  GrowthData(this.id, this.date, this.height);
}
