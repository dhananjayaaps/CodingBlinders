import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String? userUid, DocName;

class ReportPage extends StatefulWidget {
  final String? patientUid;

  ReportPage({this.patientUid});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<dynamic> reports = [];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    var url = Uri.parse(
        'https://api.realhack.saliya.ml:9696/api/v1/report/get/' +
            widget.patientUid!);
    var response = await http.get(url, headers: {
      'authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MGNkZTQ2ZmVmN2M0Zjc1NTBjNDQ4MCIsInJvbGUiOiJkb2N0b3IiLCJpYXQiOjE2Nzg1NzYxODMsImV4cCI6MTY4MTE2ODE4M30.KiFngcQf6SofXFze_DKj0W03hCpuog81opSuiTOyhsM'
    });

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      userUid = prefs.getString('uid') ?? '';
      setState(() {
        reports = jsonDecode(response.body)['data'];
      });
    } else {
      print('Error fetching reports: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          var report = reports[index];
          findDoctorName(reports[index]['doctorUid']);
          bool isCurrentUserReport = report['doctorUid'] == userUid;

          return Card(
            child: Container(
              decoration: BoxDecoration(
                color: isCurrentUserReport
                    ? Colors.green.shade100
                    : Colors.yellow.shade100,
                border: Border.all(
                  color: isCurrentUserReport
                      ? Colors.green.shade400
                      : Colors.yellow.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Doctor Name: ${DocName ?? ''}'),
                      if (isCurrentUserReport) Icon(Icons.update),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Date and Time: ${report['createdAt']}'),
                  SizedBox(height: 15),
                  Text('Disease Reason: ${report['diseaseReason']}'),
                  SizedBox(height: 8),
                  Text('Prescriptions: ${report['prescriptions'] ?? 'None'}'),
                  SizedBox(height: 8),
                  Text('Treatment Plan: ${report['treatmentPlan']}'),
                  SizedBox(height: 8),
                  Text('Progress Notes: ${report['progressNotes']}'),
                ],
              ),
            ),
          );
        },
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
