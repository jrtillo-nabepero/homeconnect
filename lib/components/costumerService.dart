import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes2_project/globals.dart';

class CostumerService extends StatelessWidget {
  const CostumerService({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Announcements",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SizedBox(
              height: 200,
              child: Announcements(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Feedback/Appointment",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
          ),
          PostText(),
        ],
      ),
    );
  }
}

class Announcements extends StatefulWidget{
  const Announcements({super.key});

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements>{
  List announcements = [];
  getAllAnnouncements() async {
    var response = await http.get(Uri.parse(urlCostumerServiceAnnounce));
    if(response.statusCode == 200){
      setState(() {
        announcements = json.decode(response.body);
      });
      return announcements;
    }
  }

  @override
  void initState(){
    super.initState();
    getAllAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26)
      ),
      child: ListView.builder(
        itemCount: announcements.length,
          itemBuilder: (context,index){
          return ListTile(
            leading: Text(announcements[index]['time_date']),
            title: Text(announcements[index]['announcement']),

          );
          }
      ),
    );
  }
}

class PostText extends StatefulWidget {
  const PostText({super.key});

  @override
  _PostText createState() => _PostText();
}

class _PostText extends State<PostText> {
  final TextEditingController _textFieldController = TextEditingController();
  String _responseText = '';
  String id = globalVariable;

  Future<void> sendFeedbackData() async {
    // API Endpoint URL (replace with the actual URL of your PHP script)

    // Data to send in the POST request
    //final String data = 'text=' + _textFieldController.text + '&id=' + id;
    final String checkText = _textFieldController.text;

    Map<String, dynamic> data = {
      'text': checkText, // Change this value as needed
      'id': id, // Change these values as needed
    };

    if(checkText.isEmpty){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Text field cannot be empty!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    else{
      final response = await http.post(Uri.parse(urlCostumerServiceFeedbacks), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: data);

      // Check the response status code (200 means success)
      if (response.statusCode == 200) {
        // Parse the response data (if applicable)
        debugPrint('POST request successful!');
        _responseText = 'Feedback sent successfully';
        _textFieldController.clear();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Your feedback is sent successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the alert dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        debugPrint('Failed to make the POST request.');
      }
    }
  }

  Future<void> sendAppointmentData() async {
    // API Endpoint URL (replace with the actual URL of your PHP script)

    // Data to send in the POST request
    //final String data = 'text=' + _textFieldController.text + '&id=' + id;
    final String checkText = _textFieldController.text;

    Map<String, dynamic> data = {
      'text': checkText, // Change this value as needed
      'id': id, // Change these values as needed
    };

    if(checkText.isEmpty){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Text field cannot be empty!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    else{
      final response = await http.post(Uri.parse(urlCostumerServiceAppointment), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: data);

      // Check the response status code (200 means success)
      if (response.statusCode == 200) {
        // Parse the response data (if applicable)
        debugPrint('POST request successful! appointment');
        _responseText = 'Feedback sent successfully';
        _textFieldController.clear();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Your appointment is sent successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the alert dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        debugPrint('Failed to make the POST request.');
      }
    }
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            keyboardType: TextInputType.multiline,
            controller: _textFieldController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Aa',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton.icon(
            onPressed: () {
              sendFeedbackData();
            },
            icon: const Icon( // <-- Icon
              Icons.feedback,
              size: 25.0,
            ),
            label: const Text('Submit Feedback'), // <-- Text
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            sendAppointmentData();
          },
          icon: const Icon( // <-- Icon
            Icons.send,
            size: 25.0,
          ),
          label: const Text('Submit Appointment'), // <-- Text
        ),
      ],
    );
  }
}
