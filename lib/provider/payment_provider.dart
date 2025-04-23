import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/firestore_references.dart';
import 'package:safmobile_portal/model/invoice.dart';

class PaymentProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  Customer? customer;
  Invoice? invoice;

  Future<void> getDocData(String uid, String ticketId) async {
    final getCustomer = await _firestore.collection(FirestoreReferences.customer).doc(uid).get();
    final getInvoice = await _firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId).get();

    customer = Customer.fromMap(getCustomer.data());
    invoice = Invoice.fromMap(getInvoice.data());
  }
}
