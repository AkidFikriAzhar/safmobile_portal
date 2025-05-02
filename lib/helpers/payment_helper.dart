import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/services/bayarcash_api.dart';
import 'package:safmobile_portal/widgets/bottomsheet/choose_payment_method_bottomsheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

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
    if (formKey.currentState!.validate()) {
      if (paymentProvider.isAgree) {
        log('initiate Api Payment Gateway');

        // paymentProvider.setLoadingApi(true);
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

        if (currentPaymentMethod != null) {
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

            final url = await BayarcashApi().createBayarCashPaymentIntent(
              name: name,
              email: email,
              phoneNumber: phone,
              amount: amount,
              ticketId: ticketId,
              paymentMethod: currentPaymentMethod,
            );

            if (context.mounted) {
              context.pop();

              if (!kIsWeb) {
                launchUrl(Uri.parse(url));
              } else {
                html.window.open(url, '_blank');
              }
              context.pushReplacementNamed(
                Routes.pending,
                pathParameters: {
                  'uid': uid,
                  'ticketId': ticketId,
                },
                queryParameters: {'paymentID': url},
              );
            } else {
              return;
            }
          } else {
            return;
          }
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
