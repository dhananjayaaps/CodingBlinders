// To parse this JSON data, do
//
//     final doctor = doctorFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';


List<Doctor> DoctormodelFromJson(String str) =>
    List<Doctor>.from(json.decode(str).map((x) => Doctor.fromJson(x)));

class Doctor {
  Doctor({
    required this.userUid,
    required this.name,
    required this.email,
    required this.specialization,
    required this.regNumber,
  });

  final String userUid;
  final String name;
  final String email;
  final String specialization;
  final String regNumber;

  Doctor copyWith({
    String? userUid,
    String? name,
    String? email,
    String? specialization,
    String? regNumber,
  }) =>
      Doctor(
        userUid: userUid ?? this.userUid,
        name: name ?? this.name,
        email: email ?? this.email,
        specialization: specialization ?? this.specialization,
        regNumber: regNumber ?? this.regNumber,
      );

  factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    userUid: json["userUid"],
    name: json["name"],
    email: json["email"],
    specialization: json["specialization"],
    regNumber: json["regNumber"],
  );

  Map<String, dynamic> toJson() => {
    "userUid": userUid,
    "name": name,
    "email": email,
    "specialization": specialization,
    "regNumber": regNumber,
  };
}
