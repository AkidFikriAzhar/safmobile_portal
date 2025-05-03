import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/extensions/route_extension.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/services/bayarcash_api.dart';
import 'package:safmobile_portal/widgets/bottomsheet/choose_payment_method_bottomsheet.dart';
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
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     backgroundColor: Colors.black.withValues(alpha: 0.7),
              //     content: Row(
              //       children: [
              //         CircularProgressIndicator(),
              //         SizedBox(width: 10),
              //         Text('Processing payment...'),
              //       ],
              //     ),
              //   ),
              // );

              final paymentId = await BayarcashApi().createBayarCashPaymentIntent(
                name: name,
                email: email,
                phoneNumber: phone,
                amount: amount,
                ticketId: ticketId,
                paymentMethod: currentPaymentMethod,
              );

              if (context.mounted) {
                context.pop();
                final url = '${BayarcashApi.paymentIntentUrlSandbox}$paymentId';
                if (!kIsWeb) {
                  launchUrl(Uri.parse(url));
                } else {
                  html.window.location.assign(url);
                }
                context.goPush(
                  Routes.pending,
                  pathParameters: {
                    'uid': uid,
                    'ticketId': ticketId,
                  },
                  queryParameters: {'paymentId': paymentId},
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
