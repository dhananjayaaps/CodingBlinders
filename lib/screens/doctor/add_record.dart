import 'package:codingblinders/screens/doctor/showAppointment.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

String? patientUi;
String? appointmentIdt;

class PatientRecordForm extends StatefulWidget {
  final String patientUid;
  final String appointmentId;

  const PatientRecordForm(
      {Key? key, required this.patientUid, required this.appointmentId})
      : super(key: key);

  @override
  _PatientRecordFormState createState() => _PatientRecordFormState();
}

class _PatientRecordFormState extends State<PatientRecordForm> {
  final _formKey = GlobalKey<FormState>();

  String? diseaseReason, prescriptions, treatmentPlan, progressNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Record Forum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Reason for Disease'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter reason for disease';
                  }
                  return null;
                },
                onSaved: (value) {
                  diseaseReason = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prescriptions'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter prescriptions';
                  }
                  return null;
                },
                onSaved: (value) {
                  prescriptions = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Treatment Plan'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter treatment plan';
                  }
                  return null;
                },
                onSaved: (value) {
                  treatmentPlan = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Progress Notes'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter progress notes';
                  }
                  return null;
                },
                onSaved: (value) {
                  progressNotes = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Make Record'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    savePatientRecord(
                        diseaseReason!,
                        prescriptions!,
                        treatmentPlan!,
                        progressNotes!,
                        widget.patientUid,
                        widget.appointmentId);
                  }
                },
              ),
              ElevatedButton.icon(
                onPressed: () {
                  viewHistory(context, widget.patientUid);
                },
                icon: Icon(Icons.history),
                label: Text('View History'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> savePatientRecord(
    String diseaseReason,
    String prescriptions,
    String treatmentPlan,
    String progressNotes,
    String patientUid,
    String appointmentId) async {
  final prefs = await SharedPreferences.getInstance();

  // final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid') ?? '';
  final token = prefs.getString('token') ?? '';

  final url =
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/report/create');

  print('Appointment ID: $appointmentId');
  print('Patient ID: $patientUid');
  print('Doctor ID: $uid');
  print('Disease Reason: $diseaseReason');
  print('Prescriptions: $prescriptions');
  print('Treatment Plan: $treatmentPlan');
  print('Progress Notes: $progressNotes');
  print('token: $token');

  final response = await http.post(
    url,
    headers: {
      'authorization': '$token',
    },
    body: json.encode({
      'appointmentUid': appointmentId,
      'patientUid': patientUid,
      'doctorUid': uid,
      'diseaseReason': diseaseReason,
      'prescriptions': prescriptions,
      'treatmentPlan': treatmentPlan,
      'progressNotes': progressNotes,
    }),
  );

  if (response.statusCode == 200) {
    print('Record saved successfully');
    // show success message
  } else {
    print('Failed to create user account.');
  }
}

void viewHistory(BuildContext context, String patientUid) {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => PatientHistory(patientUid: patientUid),
  //   ),
  // );
}
