import 'dart:convert';
import 'package:tes2_project/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const Container4());

class Container4 extends StatelessWidget {
  const Container4({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Icon(
                      Icons.speaker,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SwitchExample(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      'Speakers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'JBL S25 Pro Max',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;

  List<dynamic> data = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(urlContainer));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        if (data[0]['device4'] == '1'){
          light = true;
        }
        else{
          light = false;
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

  Future<void> _makePostRequestTrue() async {
    // API Endpoint URL (replace with the actual URL of your PHP script)
    // Data to send in the POST request

    Map<String, dynamic> postData = {
      'state': '1', // Change this value as needed
      'device': '4', // Change these values as needed
      'id': globalVariable, // Change these values as needed
    };

    final response = await http.post(Uri.parse(urlContainer), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: postData);

    // Check the response status code (200 means success)
    if (response.statusCode == 200) {
      // Parse the response data (if applicable)
      debugPrint('POST request successful!');

    } else {
      debugPrint('Failed to make the POST request.');
    }
  }

  Future<void> _makePostRequestFalse() async {
    // API Endpoint URL (replace with the actual URL of your PHP script)
    // Data to send in the POST request

    Map<String, dynamic> postData = {
      'state': '0', // Change this value as needed
      'device': '4', // Change these values as needed
      'id': globalVariable, // Change these values as needed
    };

    // Encode the data to JSON format
    //String jsonData = json.encode(postData);

    // Set headers (content-type and any other required headers)
    // Send the POST request with application/x-www-form-urlencoded headers
    final response = await http.post(Uri.parse(urlContainer), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: postData);

    // Check the response status code (200 means success)
    if (response.statusCode == 200) {
      // Parse the response data (if applicable)
      debugPrint('POST request successful!');
    } else {
      debugPrint('Failed to make the POST request.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.greenAccent,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
        if (light == true){
          _makePostRequestTrue();
          debugPrint("On");
        }
        else{
          _makePostRequestFalse();
          debugPrint("Off");
        }
      },
    );
  }
}
