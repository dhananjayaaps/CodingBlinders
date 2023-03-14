//testing file

import 'package:flutter/material.dart';

class StaffNurseHome extends StatefulWidget {
  @override
  _StaffNurseHomeState createState() => _StaffNurseHomeState();
}

class _StaffNurseHomeState extends State<StaffNurseHome> {
  final _formKey = GlobalKey<FormState>();

  String? diseaseReason, prescriptions, treatmentPlan, progressNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Record Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Reason for Disease'),
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
            ],
          ),
        ),
      ),
    );
  }
}
