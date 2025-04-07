import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/model/jobsheet.dart';

class SearchFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<dynamic>> searchDocuments(String referenceNumber) async {
    final List<dynamic> results = [];

    //search dalam collectionGroup
    final invoiceSnapshot = await _firestore.collectionGroup('Invoice').where('id', isEqualTo: int.parse(referenceNumber)).get();

    print('$referenceNumber ${invoiceSnapshot.docs.length}');

    for (var doc in invoiceSnapshot.docs) {
      if (doc.reference.parent.id == 'Invoice') {
        results.add(Invoice.fromMap(doc.data()));
      }
    }
    final serviceOrderSnapshot = await _firestore.collectionGroup('Service Order').where('ticketID', isEqualTo: int.parse(referenceNumber)).get();

    for (var doc in serviceOrderSnapshot.docs) {
      if (doc.reference.parent.id == 'Service Order') {
        results.add(Jobsheet.fromMap(doc.data()));
      }
    }

    return results;
  }
}
