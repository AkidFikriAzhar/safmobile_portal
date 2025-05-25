import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
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

class _PendingPaymentViewState extends State<PendingPaymentView> with TickerProviderStateMixin {
  late AnimationController _controllerLottiePending;
  late AnimationController _controllerLottieCompleted;
  late Stream _billStream;
  int _countdown = 60;
  late Timer _timer;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _controllerLottiePending = AnimationController(vsync: this);
    _controllerLottieCompleted = AnimationController(vsync: this);
    _controllerLottieCompleted.addListener(() {
      if (_controllerLottieCompleted.isCompleted) {
        _controllerLottieCompleted.stop();
      }
    });
    _billStream = FirebaseFirestore.instance.collection(FirestoreReferences.customer).doc(widget.uid).collection(FirestoreReferences.invoices).doc(widget.ticketId).snapshots();
  }

  @override
  void dispose() {
    _controllerLottiePending.dispose();
    _controllerLottieCompleted.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        setState(() => _isButtonEnabled = true);
        _timer.cancel();
      }
    });
  }

  //debug only = /#/docs/JjgBq7I1ZpdEFKES6lPwP5n9aA03/116507/pending?paymentId=9e6516abc5560e3a
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Center(
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
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
                    Text(
                      context.localization.paymentCompleted,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(context.localization.paymentCompletedDescription, textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 350,
                      height: 40,
                      child: FilledButton(
                        onPressed: () {
                          context.pop();
                          context.pop();
                        },
                        child: Text(context.localization.returnToMainPortal),
                      ),
                    ),
                  ],
                ),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;

                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: width,
                    constraints: BoxConstraints(
                      minHeight: height,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20),
                        Column(
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
                            const SizedBox(height: 20),
                            Text(
                              context.localization.paymentProcessing,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              context.localization.paymentProcessingDescription,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                final url = '${BillPlizApi.sandboxBaseUrl}${widget.billCode}';
                                if (!kIsWeb) {
                                  launchUrl(Uri.parse(url));
                                } else {
                                  html.window.open(url, '_blank');
                                }
                              },
                              child: Text(context.localization.reopenPaymentPage),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          height: 45,
                          child: FilledButton(
                            onPressed: _isButtonEnabled
                                ? () {
                                    context.pop();
                                    context.pop();
                                  }
                                : null,
                            child: _isButtonEnabled ? Text(context.localization.returnToMainPortal) : Text('${context.localization.returnToMainPortal} (${_countdown}s)'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    ));
  }
}
