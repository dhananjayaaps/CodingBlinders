import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/doctormodel2.dart';
import 'edit_profile_doctor.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: FutureBuilder(
            future: fetchDoctor(),
            builder: (context, snapshot) {
              print(snapshot.toString());
              if (snapshot.hasData) {
                final doctor = snapshot.data as Doctormodel;
                return SingleChildScrollView (
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                          child: Image.asset('assets/icons/female-doctor.jpg')),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Name: ${doctor.name}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Email: ${doctor.email}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Specialization: ${doctor.specialization}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Registration Number: ${doctor.regNumber}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Address: ${doctor.address}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Telephone: ${doctor.telephone}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Active Times:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var activeTime in doctor.activeTimes)
                              Container(
                                color: Colors.black26,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '- ${activeTime.getTime()} (max: ${activeTime.getMax()})',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileDoctor()),
                          ),
                          child: Text('Update Data'),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

Future<Doctormodel> fetchDoctor() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid') ?? '';
  final token = prefs.getString('token') ?? '';
  print(token);
  final response = await http.get(
    Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/admin/one/' + uid),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MGNkZTQ2ZmVmN2M0Zjc1NTBjNDQ4MCIsInJvbGUiOiJkb2N0b3IiLCJpYXQiOjE2Nzg1NzYxODMsImV4cCI6MTY4MTE2ODE4M30.KiFngcQf6SofXFze_DKj0W03hCpuog81opSuiTOyhsM',
    },
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    print(response.body);
    return Doctormodel(
      name: json['name'],
      email: json['email'],
      specialization: json['specialization'],
      regNumber: json['regNumber'],
      address: json['address'],
      telephone: json['telephone'],
      activeTimes: List<ActiveTime>.from(json['activeTimes']
          .map((x) => ActiveTime(time: x['time'], max: int.parse(x['max'])))),

    );
  } else {
    throw Exception('Failed to fetch doctor');
  }
}
