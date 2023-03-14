import 'package:codingblinders/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _birthday;
  String? _selectedGender,
      fullname,
      address,
      email,
      telephone,
      password,
      gender,
      formatted_birthday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Address';
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _birthday == null
                      ? ''
                      : DateFormat('yyyy-MM-dd').format(_birthday!),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Select Your Birthday';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _birthday = DateTime.parse(value);
                    formatted_birthday =
                        DateFormat('yyyy-MM-dd').format(_birthday!);
                  }
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
                    value: 'male',
                  ),
                  DropdownMenuItem(
                    child: Text('Female'),
                    value: 'female',
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
              ElevatedButton(
                onPressed: _submit,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _birthday = selectedDate;
      });
    }
  }

  void _submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      print('Full Name: $fullname');
      print('email: $email');
      print('Address: $address');
      print('Telephone: $telephone');
      print('Password: $password');
      print('Birthday: $formatted_birthday');
      print('Gender: $gender');

      // Call the createUserAccount method with the collected attributes here
      bool accountCreated = await createUserAccount(fullname!, address!, email!,
          telephone!, password!, gender!, formatted_birthday!);

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
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
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

Future<bool> createUserAccount(String fullname, String address, String email,
    String telephone, String password, String gender, String birthday) async {
  final url =
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/user/create');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': fullname,
      'address': address,
      'email': email,
      'telephone': telephone,
      'password': password,
      'gender': gender,
      'birthday': birthday,
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
