import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/extensions/route_extension.dart';
import 'package:safmobile_portal/model/firestore_references.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/services/bayarcash_api.dart';
import 'package:safmobile_portal/services/billplz_api.dart';
import 'package:safmobile_portal/widgets/bottomsheet/choose_payment_method_bottomsheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as html;

class PaymentHelper {
  Future<void> choosePaymentMethod({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required PaymentProvider paymentProvider,
    required String ticketId,
    required String uid,
    required double amount,
    required String name,
    required String email,
    required String phone,
  }) async {
    final firestore = FirebaseFirestore.instance;
    try {
      if (formKey.currentState!.validate()) {
        log('initiate Api Payment Gateway');

        // paymentProvider.setLoadingApi(true);

        showDialog(
            context: context,
            // barrierDismissible: false,
            builder: (context) {
              return _loading(context);
            });

        // if (currentPaymentMethod != null) {
        //   if (context.mounted) {

        final paymentApiProvider = await firestore.collection('Settings').doc('payment-gateway').get();

        String currentProviderId = paymentApiProvider.data()!['currentProviderId'];

        if (currentProviderId == 'billplz') {
          final paymentId = await BillPlizApi.createInvoiceFromFunctions(
            name: name,
            email: email,
            amount: amount,
            mobile: phone,
            ticketId: ticketId,
            userId: uid,
          );
          final invoiceRef = firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId);
          await invoiceRef.update(
            {
              'payment_id': paymentId,
              'paymentMethod': 'Billplz',
            },
          );
          final paymentIDRef = firestore.collection(FirestoreReferences.paymentId).doc(paymentId);

          await paymentIDRef.set({
            'uid': uid,
            'ticketId': ticketId,
            'paymentId': paymentId,
            'createAt': Timestamp.now(),
          });

          if (context.mounted) {
            context.pop();
            showDialog(
                context: context,
                // barrierDismissible: false,
                builder: (context) {
                  return _terms(context, paymentId, uid, ticketId, currentProviderId);
                });
          } else {
            return;
          }
        } else if (currentProviderId == 'bayarcash') {
          log('init bayarcash api');

          if (!context.mounted) return;
          // context.pop();
          final currentPaymentMethod = await showModalBottomSheet<int>(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              builder: (context) {
                return ChangeNotifierProvider(
                  create: (BuildContext context) => PaymentProvider(),
                  child: ChoosePaymentMethodBottomsheet(),
                );
              });

          if (currentPaymentMethod == null) {
            if (!context.mounted) return;
            context.pop();
            return;
          }

          // final String paymentId = await Future.delayed(const Duration(seconds: 2), () async {
          //   return 'Yahahah you found me!';
          // });
          final paymentId = await BayarcashApi().createBayarCashPaymentIntentFromFunctions(
            name: name,
            email: email,
            phoneNumber: phone,
            amount: amount,
            ticketId: ticketId,
            paymentMethod: currentPaymentMethod,
          );
          final invoiceRef = firestore.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId);
          await invoiceRef.update(
            {
              'payment_id': paymentId,
              'paymentMethod': 'BayarCash',
            },
          );
          final paymentIDRef = firestore.collection(FirestoreReferences.paymentId).doc(ticketId);

          await paymentIDRef.set({
            'uid': uid,
            'ticketId': ticketId,
            'paymentId': paymentId,
            'createAt': Timestamp.now(),
          });
          if (context.mounted) {
            context.pop();
            showDialog(
                context: context,
                // barrierDismissible: false,
                builder: (context) {
                  return _terms(context, paymentId, uid, ticketId, currentProviderId);
                });
          } else {
            return;
          }
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Text(
              'Error: $e',
            ),
          ),
        );
      }
    }
  }

  AlertDialog _terms(BuildContext context, String? paymentId, String uid, String ticketId, String currentProviderId) {
    return AlertDialog(
      title: Text(context.localization.confirmPayment),
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${context.localization.confirmPaymentDescription} ',
            ),
            TextSpan(
              text: context.localization.termsAndConditions,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final url = 'https://safmobile.my/terms/';
                  if (!kIsWeb) {
                    launchUrl(Uri.parse(url));
                  } else {
                    html.window.open(url, '_blank');
                  }
                },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(context.localization.cancel, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
        TextButton(
          onPressed: () async {
            context.pop();
            // final url = '${BillPlizApi.baseUrl}$paymentId';
            String url = '';
            if (currentProviderId == 'billplz') {
              url = '${BillPlizApi.baseUrl}$paymentId';
            } else if (currentProviderId == 'bayarcash') {
              url = '${BayarcashApi.paymentIntentUrlProduction}$paymentId';
            }
            context.goPush(
              Routes.pending,
              pathParameters: {
                'uid': uid,
                'ticketId': ticketId,
              },
              queryParameters: {'url': url},
            );
            if (!kIsWeb) {
              launchUrl(Uri.parse(url));
            } else {
              html.window.open(url, '_blank');
            }
          },
          child: Text(context.localization.agreeContinue),
        ),
      ],
    );
  }

  AlertDialog _loading(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 15),
          Text(
            context.localization.pleaseWaitCreatingBill,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
