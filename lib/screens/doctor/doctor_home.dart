import 'package:flutter/material.dart';
import 'profile.dart';
import 'showAppointment.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codingblinders/main.dart';

class DoctorView extends StatefulWidget {
  @override
  _DoctorViewState createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ProfilePage(),
    DoctorViewWidget(),
    AppointmentList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Patient View"),
      // ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Show',
          ),
        ],
      ),
    );
  }
}

class DoctorViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Text(
            'Welcome to National Hospital',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Centre of Excellence in Health Care',
            style: TextStyle(
              fontSize: 24,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            child: Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        viewportFraction: 2,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      items: [
                        Image.network(
                            'http://www.nhsl.health.gov.lk/web/images/h-slide-5.jpg'),
                        Image.network(
                            'http://www.nhsl.health.gov.lk/web/images/h-slide-3.jpg'),
                        Image.network(
                            'http://www.nhsl.health.gov.lk/web/images/h-slide-4.jpg'),
                        Image.network(
                            'http://www.nhsl.health.gov.lk/web/images/h-slide-21.jpg'),
                        // Image.network('https://cdn.hirunews.lk/Data/News_Images/202004/1587210106_650168_hirunews_Genaral-Hospital.jpg'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'The National Hospital of Sri Lanka situated in Colombo in a 32 acre block of land is the largest teaching hospital in Sri Lanka and the final referral centre in the country consisting of 3000 beds. it is the training centre for under graduates and post graduate trainees of the Faculty of Medicine. The nursing training school, Colombo, PBS, and Schools of Radiography, Pharmacy, Cardiograph, physiotherapy and occupational therapy are also affiliated to the National Hospital.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: () {
                              signOut(context);
                            },
                            child: Text("Sign Out"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignOut {
  static Future<void> signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => DoctorView()),
    );
  }
}
