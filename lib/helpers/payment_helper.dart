import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/extensions/route_extension.dart';
import 'package:safmobile_portal/model/firestore_references.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/services/billplz_api.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

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
        // final currentPaymentMethod = await showModalBottomSheet<int>(
        //     context: context,
        //     isScrollControlled: true,
        //     enableDrag: true,
        //     builder: (context) {
        //       return ChangeNotifierProvider(
        //         create: (BuildContext context) => PaymentProvider(),
        //         child: ChoosePaymentMethodBottomsheet(),
        //       );
        //     });

        showDialog(
            context: context,
            // barrierDismissible: false,
            builder: (context) {
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
            });

        // if (currentPaymentMethod != null) {
        //   if (context.mounted) {

        final paymentId = kIsWeb
            ? await BillPlizApi.createInvoiceFromFunctions(
                name: name,
                email: email,
                amount: amount,
                mobile: phone,
                ticketId: ticketId,
                userId: uid,
              )
            : await BillPlizApi.createInvoice(
                name: name,
                email: email,
                amount: amount,
                mobile: phone,
                ticketId: ticketId,
                userId: uid,
              );
        final invoiceRef = firestore
            .collection(FirestoreReferences.customer)
            .doc(uid)
            .collection(FirestoreReferences.invoices)
            .doc(ticketId);
        await invoiceRef.update(
          {
            'payment_id': paymentId,
            'paymentMethod': 'Billplz',
          },
        );
        final paymentIDRef =
            firestore.collection(FirestoreReferences.paymentId).doc(paymentId);

        await paymentIDRef.set({
          'uid': uid,
          'ticketId': ticketId,
          'paymentId': paymentId,
          'createAt': Timestamp.now(),
        });
        // final paymentId = await BayarcashApi().createBayarCashPaymentIntent(
        //   name: name,
        //   email: email,
        //   phoneNumber: phone,
        //   amount: amount,
        //   ticketId: ticketId,
        //   paymentMethod: currentPaymentMethod,
        // );

        if (context.mounted) {
          context.pop();
          showDialog(
              context: context,
              // barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(context.localization.confirmPayment),
                  content: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${context.localization.confirmPaymentDescription} ',
                        ),
                        TextSpan(
                          text: context.localization.termsAndConditions,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
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
                      child: Text(context.localization.cancel,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    ),
                    TextButton(
                      onPressed: () async {
                        context.pop();
                        final url = '${BillPlizApi.baseUrl}$paymentId';
                        context.goPush(
                          Routes.pending,
                          pathParameters: {
                            'uid': uid,
                            'ticketId': ticketId,
                          },
                          queryParameters: {'paymentId': paymentId},
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
              });
        } else {
          return;
        }
        // } else {
        //   return;
        // }
        // }
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
}
