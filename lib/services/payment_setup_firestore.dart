import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safmobile_portal/model/firestore_references.dart';

class PaymentSetupFirestore {
  static Future<DocumentSnapshot<Map<String, dynamic>>> getInvoice(String uid, String ticketId) async {
    final firestore = FirebaseFirestore.instance;
    final getInvoice = await firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId).get();
    return getInvoice;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getCustomer(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final getCustomer = await firestore.collection(FirestoreReferences.customer).doc(uid).get();
    return getCustomer;
  }

  static Stream<bool> getPaymentStatusStream(String uid, String ticketId) {
      final firestore = FirebaseFirestore.instance;
  return firestore
      .collection(FirestoreReferences.customer)
      .doc(uid)
      .collection(FirestoreReferences.invoices)
      .doc(ticketId)
      .snapshots()
      .map((doc) {
    if (doc.exists) {
      return doc.data()?['isPay'] ?? false;
    }
    return false;
  });
}

  static Future<void> updateCustomer({
    required String uid,
    required String ticketId,
    required String name,
    required String phoneNumber,
    required String email,
  }) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection(FirestoreReferences.customer).doc(uid).update({
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    });
  }

  static Future<void> updateInvoice({
    required String uid,
    required String ticketId,
    required String paymentId,
  }) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId).update(
      {
        'paymentID': paymentId,
        'paymentStatus': 'Pending',
        'isPay': false,
      },
    );
  }
}
