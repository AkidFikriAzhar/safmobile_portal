import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/extensions/route_extension.dart';
import 'package:safmobile_portal/model/firestore_references.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/services/billplz_api.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
// import 'package:universal_html/html.dart' as html;
// import 'package:url_launcher/url_launcher.dart';

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
                      'Please wait while we process your payment...',
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
        final ref = FirebaseFirestore.instance.collection(FirestoreReferences.customer).doc(uid).collection(FirestoreReferences.invoices).doc(ticketId);
        await ref.update(
          {
            'payment_id': paymentId,
            'paymentMethod': 'Billplz',
          },
        );
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
                  title: Text('Confirm Payment'),
                  content: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'You will be redirect to the Billplz payment page. By proceeding, you agree to our ',
                        ),
                        TextSpan(
                          text: 'Terms & Conditions.',
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
                      child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ),
                    TextButton(
                      onPressed: () async {
                        context.pop();
                        final url = '${BillPlizApi.sandboxBaseUrl}$paymentId';
                        if (!kIsWeb) {
                          launchUrl(Uri.parse(url));
                        } else {
                          html.window.open(url, '_blank');
                        }
                        context.goPush(
                          Routes.pending,
                          pathParameters: {
                            'uid': uid,
                            'ticketId': ticketId,
                          },
                          queryParameters: {'paymentId': paymentId},
                        );
                      },
                      child: Text('Agree & Continue'),
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
