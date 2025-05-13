import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  const PendingPaymentView({super.key, required this.uid, required this.ticketId, required this.billCode});

  @override
  State<PendingPaymentView> createState() => _PendingPaymentViewState();
}

class _PendingPaymentViewState extends State<PendingPaymentView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Stream _billStream;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _billStream = FirebaseFirestore.instance.collection(FirestoreReferences.customer).doc(widget.uid).collection(FirestoreReferences.invoices).doc(widget.ticketId).snapshots();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                return const Center(child: Text('Payment Confirmed'));
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/pending_payment.json',
                    width: 200,
                    height: 200,
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration * 1.8
                        ..repeat();
                    },
                  ),
                  const Text(
                    'Waiting For Payment Confimation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Please do not close this tab or reload the page while your payment is being processed\n\n',
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
                                final url = '${BillPlizApi.sandboxBaseUrl}${widget.billCode}';
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
