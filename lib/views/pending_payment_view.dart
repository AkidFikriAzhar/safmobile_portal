import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:safmobile_portal/services/bayarcash_api.dart';
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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    // Future.delayed(const Duration(seconds: 2), () {

    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
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
                              final url = '${BayarcashApi.paymentIntentUrlSandbox}${widget.billCode}';
                              if (!kIsWeb) {
                                launchUrl(Uri.parse(url));
                              } else {
                                html.window.location.assign(url);
                              }
                            }),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ));
  }
}
