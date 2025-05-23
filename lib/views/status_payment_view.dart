import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:safmobile_portal/model/firestore_references.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/services/billplz_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

class PendingPaymentView extends StatefulWidget {
  final String uid;
  final String ticketId;
  final String billCode;
  const PendingPaymentView(
      {super.key,
      required this.uid,
      required this.ticketId,
      required this.billCode});

  @override
  State<PendingPaymentView> createState() => _PendingPaymentViewState();
}

class _PendingPaymentViewState extends State<PendingPaymentView>
    with TickerProviderStateMixin {
  late AnimationController _controllerLottiePending;
  late AnimationController _controllerLottieCompleted;
  late Stream _billStream;

  @override
  void initState() {
    super.initState();
    _controllerLottiePending = AnimationController(vsync: this);
    _controllerLottieCompleted = AnimationController(vsync: this);
    _controllerLottieCompleted.addListener(() {
      if (_controllerLottieCompleted.isCompleted) {
        _controllerLottieCompleted.stop();
      }
    });
    _billStream = FirebaseFirestore.instance
        .collection(FirestoreReferences.customer)
        .doc(widget.uid)
        .collection(FirestoreReferences.invoices)
        .doc(widget.ticketId)
        .snapshots();
  }

  @override
  void dispose() {
    _controllerLottiePending.dispose();
    _controllerLottieCompleted.dispose();
    super.dispose();
  }

  //debug only = /#/docs/JjgBq7I1ZpdEFKES6lPwP5n9aA03/116507/pending?paymentId=9e6516abc5560e3a
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: StreamBuilder(
            stream: _billStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('An error has occurred'));
              }

              final invoice = Invoice.fromMap(snapshot.data!.data()!);

              if (invoice.isPay == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/payment_completed.json',
                      width: 200,
                      height: 200,
                      controller: _controllerLottieCompleted,
                      onLoaded: (composition) {
                        _controllerLottieCompleted
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                    const Text(
                      'Payment Completed',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'We have successfully received your payment. You may have safely return to receipt page',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 350,
                      height: 40,
                      child: FilledButton(
                        onPressed: () {
                          context.pop();
                          context.pop();
                        },
                        child: Text('Return to receipt page'),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/pending_payment.json',
                    width: 200,
                    height: 200,
                    controller: _controllerLottiePending,
                    onLoaded: (composition) {
                      _controllerLottiePending
                        ..duration = composition.duration * 1.8
                        ..repeat();
                    },
                  ),
                  const Text(
                    'Your Payment Has Been Processed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'If your payment is successfull, it will be automatically reflected in our system.\n\n',
                        ),
                        TextSpan(
                            text: 'Reopen Payment Page',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // context.goPush(
                                //   Routes.paymentGateway,
                                //   pathParameters: {
                                //     'uid': widget.uid,
                                //     'ticketId': widget.ticketId,
                                //   },
                                //   queryParameters: {'paymentId': widget.billCode},
                                // );
                                final url =
                                    '${BillPlizApi.sandboxBaseUrl}${widget.billCode}';
                                if (!kIsWeb) {
                                  launchUrl(Uri.parse(url));
                                } else {
                                  html.window.open(url, '_blank');
                                }
                              }),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }),
      ),
    ));
  }
}
