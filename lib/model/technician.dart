import 'package:cloud_firestore/cloud_firestore.dart';

class Technician {
  final String uid;
  final String name;
  final int noPhone;
  final String email;
  final String noIc;
  final String jawatan;
  final String branch;
  final String branchText;
  final String photoUrl;
  final int totalRepair;
  final List<dynamic> token;
  final double rating;
  final Timestamp timeStamp;

  Technician({
    required this.uid,
    required this.name,
    required this.noPhone,
    required this.email,
    required this.noIc,
    required this.jawatan,
    required this.branch,
    required this.photoUrl,
    required this.branchText,
    required this.totalRepair,
    required this.token,
    required this.rating,
    required this.timeStamp,
  });

  factory Technician.fromMap(dynamic json) {
    return Technician(
      uid: json['uid'],
      name: json['name'],
      noPhone: json['noPhone'],
      email: json['email'],
      noIc: json['noIc'],
      jawatan: json['jawatan'],
      branch: json['branch'],
      photoUrl: json['photoUrl'],
      totalRepair: json['totalRepair'] as int,
      token: json['token'],
      rating: json['rating'] as double,
      timeStamp: json['timeStamp'] as Timestamp,
      branchText: json['branchText'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'noPhone': noPhone,
      'email': email,
      'noIc': noIc,
      'jawatan': jawatan,
      'branch': branch,
      'photoUrl': photoUrl,
      'totalRepair': totalRepair,
      'token': [],
      'rating': rating,
      'brachText': branchText,
      'timeStamp': FieldValue.serverTimestamp(),
    };
  }
}
