import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin/admin_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctor/add_record.dart';
import 'user/user_home.dart';
import 'Staff/StaffNurseHome.dart';
import 'package:codingblinders/screens/doctor/doctor_home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Call the login function with the username and password
    login(context, username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/icons/splash_bg.svg",
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.all(10.00),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'User Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    // Update the username value when the text changes
                    // (this is not necessary, but may be useful if you
                    // want to perform validation or other processing
                    // on the input values)
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    // Update the password value when the text changes
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50.00,
                  width: 300.00,
                  child: ElevatedButton(
                    onPressed: () {
                      _login(); // Call the login function on button press
                    },
                    style: TextButton.styleFrom(
                      // backgroundColor: Color(0xFF6CD8D1),
                      elevation: 0,

                      backgroundColor: Colors.blue[600],

                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFF6CD8D1)),
                      ),
                    ),
                    child: Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> login(BuildContext context, String email, String password) async {
  final url =
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/user/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    // Login successful, navigate to adminHome screen
    final responseData = json.decode(response.body);
    print(responseData);

    // Save user data locally
    final uid = responseData['uid'];
    final token = responseData['token'];
    final role = responseData['role'];
    saveUserData(uid, token, role);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChooseRole(role: role)),
    );
  } else {
    // Login failed, display error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Credentials'),
          content: Text('Please enter valid email and password.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> saveUserData(String uid, String token, String role) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('uid', uid);
  prefs.setString('token', token);
  prefs.setString('role', role);
}

class ChooseRole extends StatelessWidget {
  final String role;

  const ChooseRole({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'doctor':
        return DoctorView();
      case 'staff':
      case 'nurse':
        return StaffNurseHome();
      case 'admin':
        return RegistrationForm();
      case 'patient':
        return HomeScreen();
      default:
        return Scaffold(
          body: Center(
            child: Text('Invalid role.'),
          ),
        );
    }
  }
}
