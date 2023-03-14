import 'package:codingblinders/screens/models/doctormodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'addAppoinment.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({Key? key}) : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  late List<Doctor>? doctorModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    doctorModel = (await ApiService().getUsers())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Home'),),
      body: doctorModel == null || doctorModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Material(
                  elevation: 5.0,
                  shadowColor: Colors.black,
                  color: Colors.blue,
                  child: Container(
                    height: 100,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            'Make An Appointment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: doctorModel!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            // Save the userUid locally
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('userUid',
                                doctorModel![index].userUid.toString());

                            // Navigate to the AddAppointment screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddApoinment(
                                      userUid: doctorModel![index]
                                          .userUid
                                          .toString())),
                            );
                          },
                          child: Card(
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.00),
                              child: Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/female-doctor.jpg',
                                      height: 155,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      doctorModel![index].name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Speciality :"),
                                        Text(
                                            doctorModel![index].specialization),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                color: Colors.green,
                                                height: 30,
                                                width: 100,
                                                child: Center(
                                                  child: Text('Available'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ApiService {
  Future<List<Doctor>?> getUsers() async {
    try {
      var url = Uri.parse(
          'https://api.realhack.saliya.ml:9696/api/v1/admin/all/:doctor');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Doctor> _model = DoctormodelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
