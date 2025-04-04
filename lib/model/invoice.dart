import 'package:admin_panel_v3/model/payment_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice {
  final int id;
  final String ownerId;
  final String techId;
  final String branchId;
  final double finalPrice;
  final double discount;
  final List<String> serviceOrderId;
  final bool isPay;
  final PaymentMethod paymentMethod;
  final Timestamp startDate;
  final Timestamp dueDate;
  final Timestamp lastUpdate;

  Invoice({
    required this.id,
    required this.ownerId,
    required this.techId,
    required this.branchId,
    required this.finalPrice,
    required this.discount,
    required this.startDate,
    required this.dueDate,
    required this.serviceOrderId,
    required this.isPay,
    required this.paymentMethod,
    required this.lastUpdate,
  });

  factory Invoice.fromMap(dynamic doc) {
    final paymentMethodString = doc['paymentMethod'] as String?;
    final getPaymentMethod = PaymentMethod.values.firstWhere(
      (e) => e.name == paymentMethodString,
      orElse: () => PaymentMethod.cash,
    );

    return Invoice(
      id: doc['id'],
      ownerId: doc['ownerId'],
      techId: doc['techId'],
      branchId: doc['branchId'],
      finalPrice: double.parse(doc['finalPrice'].toString()),
      discount: double.parse(doc['discount'].toString()),
      dueDate: doc['dueDate'],
      isPay: doc['isPay'],
      startDate: doc['startDate'],
      lastUpdate: doc['lastUpdate'],
      serviceOrderId: List<String>.from(doc['serviceOrderId']),
      paymentMethod: getPaymentMethod,
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      'id': id,
      'ownerId': ownerId,
      'techId': techId,
      'branchId': branchId,
      'discount': discount,
      'finalPrice': finalPrice,
      'dueDate': dueDate,
      'isPay': isPay,
      'startDate': startDate,
      'lastUpdate': lastUpdate,
      'paymentMethod': paymentMethod.name,
      'serviceOrderId': serviceOrderId,
    };
  }
}

class InvoiceItem {
  final int itemId;
  final String partsId;
  final String itemName;
  final Timestamp? warrantyStart;
  final Timestamp? warrantyEnd;
  final double itemPrice;

  InvoiceItem({
    required this.itemId,
    required this.partsId,
    required this.itemName,
    required this.warrantyStart,
    required this.warrantyEnd,
    required this.itemPrice,
  });

  factory InvoiceItem.fromJson(dynamic json) {
    return InvoiceItem(
      itemId: int.parse(json['itemId'].toString()),
      partsId: json['partsId'] ?? '',
      itemName: json['itemName'] ?? '',
      warrantyStart: json['warrantyStart'] ?? Timestamp.now(),
      warrantyEnd: json['warrantyEnd'] ?? Timestamp.now(),
      itemPrice: double.parse(json['itemPrice'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'partsId': partsId,
      'itemName': itemName,
      'warrantyStart': warrantyStart,
      'warrantyEnd': warrantyEnd,
      'itemPrice': itemPrice,
    };
  }
}
