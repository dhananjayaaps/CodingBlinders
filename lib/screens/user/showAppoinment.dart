import 'dart:convert';

import 'package:codingblinders/screens/doctor/add_record.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Appointment {
  final String id;
  final String patientUid;
  final String doctorUid;
  final String date;
  final String time;
  final String status;

  Appointment({
    required this.id,
    required this.patientUid,
    required this.doctorUid,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'],
      patientUid: json['patientUid'],
      doctorUid: json['doctorUid'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }
}

class ShowAppoinments extends StatefulWidget {
  const ShowAppoinments({Key? key}) : super(key: key);

  @override
  _ShowAppoinmentsState createState() => _ShowAppoinmentsState();
}

String DocName = '';

class _ShowAppoinmentsState extends State<ShowAppoinments> {
  List<Appointment> _appointments = [];

  Future<void> _fetchAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uid = prefs.getString('uid') ?? '';
    final response = await http.get(
        Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/user/' + uid));
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _appointments = (responseData['data']['appointments'] as List)
            .map((appointmentJson) => Appointment.fromJson(appointmentJson))
            .toList();
      });
    } else {
      print(responseData['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _appointments.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            final appointment = _appointments[index];

            findDoctorName(appointment.doctorUid);
            final color =
                appointment.status == 'active' ? Colors.green : Colors.red;

            return Card(
              color: color.shade50,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: color.shade100, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DocName ?? ''),
                    Text(appointment.date),
                    Text(appointment.time),
                    Text(appointment.status),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<String> findDoctorName(String doctorUid) async {
  final apiUrl = 'https://api.realhack.saliya.ml:9696/api/v1/admin/all/:doctor';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    for (final doctor in data) {
      if (doctor['userUid'] == doctorUid) {
        print(doctor['name']);
        DocName = doctor['name'];
        return doctor['name'];
      }
    }

    // No doctor with matching uid found
    return '';
  } else {
    throw Exception('Failed to retrieve doctor information');
  }
}
