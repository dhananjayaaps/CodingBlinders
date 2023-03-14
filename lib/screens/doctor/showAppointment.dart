import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'add_record.dart';
import 'seeReport.dart';

Future<List<Appointment>> getAppointments() async {
  final prefs = await SharedPreferences.getInstance();
  final doctorUid = prefs.getString('uid') ?? '';
  final response = await http.get(
      Uri.parse(
          'https://api.realhack.saliya.ml:9696/api/v1/admin/one/$doctorUid'),
      headers: {
        'authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MGNkZTQ2ZmVmN2M0Zjc1NTBjNDQ4MCIsInJvbGUiOiJkb2N0b3IiLCJpYXQiOjE2Nzg1NzYxODMsImV4cCI6MTY4MTE2ODE4M30.KiFngcQf6SofXFze_DKj0W03hCpuog81opSuiTOyhsM'
      });
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final appointmentsList = (jsonData['appointments'] as List)
        .map((appointmentJson) => Appointment.fromJson(appointmentJson))
        .toList();
    return appointmentsList;
  } else {
    throw Exception('Failed to load appointments');
  }
}

class Appointment {
  final String id;
  final String patientUid;
  final String doctorUid;
  final String date;
  final String time;
  final String status;

  Appointment(
      {required this.id,
      required this.patientUid,
      required this.doctorUid,
      required this.date,
      required this.time,
      required this.status});

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

String? patientName;

class AppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointments',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
        ),
        body: FutureBuilder(
          future: getAppointments(),
          builder: (context, AsyncSnapshot<List<Appointment>> snapshot) {
            if (snapshot.hasData) {
              final appointments = snapshot.data!;
              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  getName(appointment.patientUid); // set patientName value
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientRecordForm(
                            patientUid: appointment.patientUid,
                            appointmentId: appointment.id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: appointment.status == 'active'
                            ? Color.fromARGB(255, 148, 237, 151)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${patientName}'),
                          Text('Appointment ID: ${appointment.id}'),
                          Text('Date: ${appointment.date}'),
                          Text('Time: ${appointment.time}'),
                          Text('Status: ${appointment.status}'),
                          ElevatedButton.icon(
                            onPressed: () {
                              viewHistory(context, appointment.patientUid);
                            },
                            icon: Icon(Icons.history),
                            label: Text('View History'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<String> getName(String patientId) async {
  final response = await http.get(
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/user/$patientId'),
      headers: {
        'authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MGNkZTQ2ZmVmN2M0Zjc1NTBjNDQ4MCIsInJvbGUiOiJkb2N0b3IiLCJpYXQiOjE2Nzg1NzYxODMsImV4cCI6MTY4MTE2ODE4M30.KiFngcQf6SofXFze_DKj0W03hCpuog81opSuiTOyhsM'
      });
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print(jsonData['data']['name']);
    patientName = jsonData['data']['name'];
    return jsonData['data']['name'];
  } else {
    throw Exception('Failed to load patient name');
  }
}

void viewHistory(BuildContext context, String patientId) {
  // ReportScreen('640ceb4cda288a89747fe292');
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ReportPage(patientUid: patientId),
    ),
  );
}
