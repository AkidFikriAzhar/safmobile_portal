import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String name;
  final String phoneNumber;
  final String email;
  final String photoURL;
  final String uid;
  final double points;
  final double totalSpent;
  final String location;
  final bool proUser;
  final Timestamp createTimestamp;
  final Timestamp lastOnlineTimestamp;

  Customer({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.photoURL,
    required this.uid,
    required this.points,
    required this.totalSpent,
    required this.proUser,
    required this.createTimestamp,
    required this.lastOnlineTimestamp,
    required this.location,
  });

  factory Customer.fromMap(dynamic json) {
    return Customer(
      name: json['name'],
      phoneNumber: json['phoneNumber'].toString(),
      email: json['email'],
      photoURL: json['photoUrl'],
      uid: json['uid'],
      points: double.parse(json['points'].toString()),
      totalSpent: double.parse(json['totalSpent'].toString()),
      proUser: json['proUser'] as bool,
      createTimestamp: json['createTimestamp'],
      lastOnlineTimestamp: json['lastOnlineTimestamp'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'photoUrl': photoURL,
      'uid': uid,
      'points': points,
      'totalSpent': totalSpent,
      'proUser': proUser,
      'createTimestamp': createTimestamp,
      'lastOnlineTimestamp': lastOnlineTimestamp,
      'location': location,
    };
  }
}
