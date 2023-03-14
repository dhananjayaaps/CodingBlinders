import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddApoinment extends StatefulWidget {
  final String userUid;

  const AddApoinment({required this.userUid, Key? key}) : super(key: key);

  @override
  State<AddApoinment> createState() => _AddApoinmentState();
}

class _AddApoinmentState extends State<AddApoinment> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedTimeSlot;

  List<String> timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Select a Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'Select a date'
                          : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            //SizedBox(height: 20),
            // Text(
            //   'Select a Time',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10),
            // GestureDetector(
            //   onTap: () async {
            //     final TimeOfDay? picked = await showTimePicker(
            //         context: context, initialTime: TimeOfDay.now());
            //     if (picked != null && picked != selectedTime)
            //       setState(() {
            //         selectedTime = picked;
            //         selectedTimeSlot = null;
            //       });
            //   },
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.grey),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           selectedTime == null
            //               ? 'Select a time'
            //               : selectedTime!.format(context),
            //           style: TextStyle(fontSize: 16),
            //         ),
            //         Icon(Icons.access_time),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              'Select a Time Slot',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: timeSlots.map((slot) {
                bool selected = selectedTimeSlot == slot;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeSlot = slot;
                      selectedTime = null;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: selectedTimeSlot == slot
                          ? Colors.blue
                          : Colors.grey[200],
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: selectedTimeSlot == slot
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Selected Time Slot: ${selectedTimeSlot ?? 'Please select a time slot'}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: selectedTimeSlot == null || selectedDate == null
                  ? null
                  : () => bookAppointment(
                      selectedDate.toString(), selectedTimeSlot!),
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> bookAppointment(String date, String timeSlot) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid') ?? '';
    final token = prefs.getString('token') ?? '';
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    String? userUid = prefs2.getString('userUid');
    var url = Uri.parse(
        'https://api.realhack.saliya.ml:9696/api/v1/appointment/create');

    DateTime appointmentDate = DateTime.parse(date);
    String formattedDate =
        '${appointmentDate.year}-${appointmentDate.month.toString().padLeft(2, '0')}-${appointmentDate.day.toString().padLeft(2, '0')}';
    print(userUid);
    print(formattedDate);
    print(timeSlot);
    print(uid);

    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': '$token',
        },
        body: jsonEncode({
          'doctor': userUid,
          'date': formattedDate,
          'time': timeSlot,
          'patient': uid,
        }));

    print(response.body);
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment successfully booked!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
        ),
      );
    }
  }
}
