class Doctormodel {
  String name;
  String email;


  String specialization;
  String regNumber;
  String address;
  String telephone;
  List<ActiveTime> activeTimes;



  factory Doctormodel.fromJson(Map<String, dynamic> json) {
    final activeTimes = List<ActiveTime>.from(json['activeTimes'].map((x) => ActiveTime(time: x['time'], max: x['max'])));
    return Doctormodel(
      name: json['name'],
      email: json['email'],


      specialization: json['specialization'],
      regNumber: json['regNumber'],
      address: json['address'],
      telephone: json['telephone'],
      activeTimes: activeTimes,
    );
  }


  Doctormodel({
    required this.name,
    required this.email,


    required this.specialization,
    required this.regNumber,
    required this.address,
    required this.telephone,
    required this.activeTimes,
  });
}

class ActiveTime {
  final String time;
  final int max;

  ActiveTime({required this.time, required this.max});

  String getTime() => time;
  int getMax() => max;
}


