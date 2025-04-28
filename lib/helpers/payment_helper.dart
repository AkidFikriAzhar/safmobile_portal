import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/routes.dart';

class PaymentHelper {
  Future<void> choosePaymentMethod({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required PaymentProvider paymentProvider,
    required String ticketId,
    required String uid,
  }) async {
    if (formKey.currentState!.validate()) {
      if (paymentProvider.isAgree) {
        log('initiate Api Payment Gateway');

        paymentProvider.setLoadingApi(true);

        if (context.mounted) {
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

          await Future.delayed(const Duration(seconds: 1));

          if (context.mounted) {
            context.pop();
            context.pushReplacementNamed(
              Routes.pending,
              pathParameters: {
                'uid': uid,
                'ticketId': ticketId,
              },
              queryParameters: {'paymentID': '23131'},
            );
          } else {
            return;
          }
        } else {
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Please agree to the terms and conditions',
          )),
        );
      }
    }
  }
}
