

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileDoctor extends StatefulWidget {
  @override
  _EditProfileDoctorState createState() => _EditProfileDoctorState();
}

class _EditProfileDoctorState extends State<EditProfileDoctor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController regNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  List<Map<Object, dynamic>> selectedActiveTimes = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<String> availableActiveTimes = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "03:30 PM",
  ];

  Future submitData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid') ?? '';
    final token = prefs.getString('token') ?? '';
    var url = Uri.parse(
        'https://api.realhack.saliya.ml:9696/api/v1/admin/update/$uid');

    //

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization':token,
      },
      body: json.encode({
        'regNumber': regNumberController.text,
        // 'specialization': "Family",
        'address': addressController.text,
        'telephone': telephoneController.text,
        'activeTimes': json.encode(selectedActiveTimes),
        'name': nameController.text,
        'email': emailController.text,
      }),
    );

    var responseData = json.decode(response.body);
    // handle the response data here

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated Successfully!'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      // print(response.body);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Doctor Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: regNumberController,
                decoration: InputDecoration(
                  labelText: 'Registration Number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the registration number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: telephoneController,
                decoration: InputDecoration(
                  labelText: 'Telephone',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the telephone number';
                  }
                  return null;
                },
              ),
              Text(
                'Select active times:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: availableActiveTimes
                    .map(
                      (time) => Column(
                        children: [
                          ChoiceChip(
                            label: Text(time),
                            selected: selectedActiveTimes.any(
                                (activeTime) => activeTime['time'] == time),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      int max = 0;
                                      return AlertDialog(
                                        title: Text('Set maximum value'),
                                        content: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Maximum',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            max = int.tryParse(value) ?? 0;
                                          },
                                        ),
                                        actions: <Widget>[
                                          OutlinedButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              if (max > 0) {
                                                selectedActiveTimes.add({
                                                  "time": '$time',
                                                  "max": '$max',
                                                });
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  selectedActiveTimes.removeWhere(
                                      (activeTime) =>
                                          activeTime['time'] == time);
                                }
                              });
                            },
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    )
                    .toList(),
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value!.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitData();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
