import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codingblinders/main.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender,
      _selectedOccu = 'staff',
      fullname,
      regNumber,
      email,
      telephone,
      password,
      role,
      address,
      gender;

  bool _showSpecialisationField = false;
  String? specialisation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Healthcare Professional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Fullname';
                  }
                  return null;
                },
                onSaved: (value) {
                  fullname = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Registration No',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a regNumber';
                  }
                  return null;
                },
                onSaved: (value) {
                  regNumber = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a address';
                  }
                  return null;
                },
                onSaved: (value) {
                  address = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Telephone',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Telephone';
                  }
                  if (value.length != 10) {
                    return 'Telephone number should be exactly 10 digits';
                  }
                  return null;
                },
                onSaved: (value) {
                  telephone = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Password';
                  } else if (value.length < 8) {
                    return 'Password must be 8 Characters Long';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'role',
                  border: OutlineInputBorder(),
                ),
                value: _selectedOccu,
                onChanged: (value) {
                  setState(() {
                    _selectedOccu = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Doctor'),
                    value: 'doctor',
                  ),
                  DropdownMenuItem(
                    child: Text('Nurse'),
                    value: 'nurse',
                  ),
                  DropdownMenuItem(
                    child: Text('Staff'),
                    value: 'staff',
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Select employee role';
                  }
                  return null;
                },
                onSaved: (value) {
                  role = value;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Male'),
                    value: 'Male',
                  ),
                  DropdownMenuItem(
                    child: Text('Female'),
                    value: 'Female',
                  ),
                  DropdownMenuItem(
                    child: Text('Other'),
                    value: 'Other',
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Select Your Gender';
                  }
                  return null;
                },
                onSaved: (value) {
                  gender = value;
                },
              ),
              SizedBox(height: 16.0),
              if (_selectedOccu == 'doctor')
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Specialisation',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Specialisation';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    specialisation = value;
                  },
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Make an account'),
              ),
              ElevatedButton(
                  onPressed: () {
                    signOut(context);
                  },
                  child: Text("Sign Out")),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      // print('Full Name: $fullname');
      // print('email: $email');
      // print('regNumber: $regNumber');
      // print('Telephone: $telephone');
      // print('Password: $password');
      // print('role: $role');

      // Call the createUserAccount method with the collected attributes here
      bool accountCreated = await createUserAccount(
          fullname!,
          regNumber!,
          email!,
          telephone!,
          password!,
          gender!,
          role!,
          specialisation!,
          address!);

      if (accountCreated) {
        // If the account was created successfully, show a success message and navigate to the home screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationForm()),
        );
      } else {
        // If there was an error creating the account, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create account. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

Future<bool> createUserAccount(
    String fullname,
    String regNumber,
    String email,
    String telephone,
    String password,
    String gender,
    String role,
    String specialisation,
    String address) async {
  final url =
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/admin/create/:');

  // Retrieve token value from local storage
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uidC') ?? '';
  final rolei = prefs.getString('roleC') ?? '';

  final token = prefs.getString('tokenC') ?? '';
  print(token + rolei);

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'authorization': '$token',
    },
    body: json.encode({
      'name': fullname,
      'regNumber': regNumber,
      'email': email,
      'telephone': telephone,
      'password': password,
      'gender': gender,
      'role': role,
      'specialization': specialisation,
      'address': address
    }),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print(responseData);
    return true;
  } else {
    print('Failed to create user account.');
    return false;
  }
}

class SignOut {
  static Future<void> signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
    );
  }
}

void signOut(BuildContext context) async {
  await clearUserData();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage()),
  );
}

Future<void> clearUserData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
