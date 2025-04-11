import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safmobile_portal/model/firestore_references.dart';

class DocsFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocsStream(String uid, String ticketId) {
    return _firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCustomerStream(String uid) {
    return _firestore.collection(FirestoreReferences.customer).doc(uid).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getTechnicianStream(String uid) {
    return _firestore.collection(FirestoreReferences.technician).doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getInvoiceItem(String uid, String ticketId) {
    return _firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId).collection('Item').snapshots();
  }
}
