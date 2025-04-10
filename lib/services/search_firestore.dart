import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/model/jobsheet.dart';
import 'package:safmobile_portal/model/search_result.dart';

class SearchFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SearchResult>> searchByReference(int refId) async {
    try {
      final invoiceSnap = await _firestore.collectionGroup('Invoice').where('id', isEqualTo: refId).get();

      final serviceOrderSnap = await _firestore.collectionGroup('Service Order').where('ticketID', isEqualTo: refId).get();

      final invoices = invoiceSnap.docs.map((doc) {
        final data = doc.data();
        return SearchResult.invoice(Invoice.fromMap(data));
      }).toList();

      final jobsheets = serviceOrderSnap.docs.map((doc) {
        final data = doc.data();
        return SearchResult.jobsheet(Jobsheet.fromMap(data));
      }).toList();

      return [...invoices, ...jobsheets];
    } catch (e) {
      log('Error searching documents: $e');
      return [];
    }
  }
}
