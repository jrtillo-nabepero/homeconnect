import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:tes2_project/components/qr_code.dart';
import 'package:tes2_project/globals.dart';

String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
String displayText = 'As of $formattedDate';
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            displayText,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            "Your electricity bill is",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Bill(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon( // <-- Icon
              Icons.qr_code,
              size: 24.0,
            ),
            label: const Text('Show QR code for payment'), // <-- Text
          ),
        ),
      ],
    );
  }
}

class Bill extends StatefulWidget {
  const Bill({super.key});

  @override
  State<Bill> createState() => _Bill();
}

class _Bill extends State<Bill> {
  bool light = false;
  String id = globalVariable;
  String bill = '₱ ';
  String dueDate ='';
  List<dynamic> data = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(urlDashboard));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        for (int i=0;i<data.length;i++) {
          if (data[i]['id1'] == id) {
            bill = bill + NumberFormat("#,##0.00", "en_US").format(double.parse(data[i]['bill']));
            debugPrint(data[i]['bill']);
            dueDate = dueDate + data[i]['bill_status'];
          }
        }
      });
    } else {
      // Handle error, e.g., data retrieval failed
      debugPrint('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            bill,
            style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            dueDate,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.orangeAccent,
            ),
          ),
        ),
      ],
    );
  }
}
