import 'package:cloud_firestore/cloud_firestore.dart';

class Jobsheet {
  final String ownerID;
  final String techID;
  final String branchID;
  final int ticketId;
  final String modelName;
  final String colour;
  final String problem;
  final String? pin;
  final List<int>? pattern;
  final String? imei;
  final double estimatePrice;
  final String? notes;
  final int progressStep;
  final String? returnReason;
  final int? returnPosition;
  final Timestamp pickupDate;
  final Timestamp estimateDone;

  Jobsheet({
    required this.ownerID,
    required this.techID,
    required this.branchID,
    required this.ticketId,
    required this.modelName,
    required this.colour,
    required this.problem,
    this.pin,
    this.pattern,
    this.imei,
    required this.estimatePrice,
    this.notes,
    required this.progressStep,
    this.returnReason,
    this.returnPosition,
    required this.pickupDate,
    required this.estimateDone,
  });

  factory Jobsheet.fromMap(dynamic json) {
    return Jobsheet(
      ownerID: json['ownerID'],
      techID: json['techID'],
      branchID: json['branchID'],
      ticketId: json['ticketID'],
      modelName: json['modelName'],
      colour: json['colour'],
      problem: json['problem'],
      pin: json['pin'],
      pattern: List<int>.from(json['pattern']),
      imei: json['imei'],
      estimatePrice: double.parse(json['estimatePrice'].toString()),
      notes: json['notes'],
      progressStep: int.parse(json['progressStep'].toString()),
      returnReason: json['returnReason'],
      returnPosition: json['returnPosition'],
      pickupDate: json['pickupDate'],
      estimateDone: json['estimateDone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerID': ownerID,
      'techID': techID,
      'branchID': branchID,
      'ticketID': ticketId,
      'modelName': modelName,
      'colour': colour,
      'problem': problem,
      'pin': pin,
      'pattern': pattern,
      'imei': imei,
      'estimatePrice': estimatePrice,
      'notes': notes,
      'progressStep': progressStep,
      'returnReason': returnReason,
      'returnPosition': returnPosition,
      'pickupDate': pickupDate,
      'estimateDone': estimateDone,
    };
  }
}
