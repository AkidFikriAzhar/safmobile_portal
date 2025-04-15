import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safmobile_portal/model/firestore_references.dart';

class ServiceOrderFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<DocumentSnapshot> getServiceOrderStream(String uid, String ticketId) {
    return _firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.serviceOrders).doc(ticketId).snapshots();
  }

  Stream<DocumentSnapshot> getCustomer(String uid) {
    return _firestore.collection(FirestoreReferences.customer).doc(uid).snapshots();
  }
}
