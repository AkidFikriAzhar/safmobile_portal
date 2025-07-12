import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/helpers/payment_helper.dart';
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/services/payment_setup_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:async';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class PaymentView extends StatefulWidget {
  final String uid;
  final String ticketId;
  const PaymentView({super.key, required this.uid, required this.ticketId});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  bool _isFetchingInvoice = true;
  bool _isFetchingCustomer = true;
  bool _isDialogShown = false; // Flag untuk tracking dialog
  bool _isScreenActive = true; // Flag untuk tracking screen status

  final _formkey = GlobalKey<FormState>();

  late Future _fetchInvoice;
  late Future _fetchCustomer;
  Invoice? invoice;
  Customer? customer;

  // Stream untuk isPay
  late StreamSubscription<bool> _paymentStatusSubscription;

  final _nameInput = TextEditingController();
  final _emailInput = TextEditingController();
  final _phoneInput = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  @override
  void initState() {
    _fetchInvoice = PaymentSetupFirestore.getInvoice(widget.uid, widget.ticketId);
    _fetchCustomer = PaymentSetupFirestore.getCustomer(widget.uid);
    // Setup stream listener untuk isPay
    _setupPaymentStatusListener();

    super.initState();
  }

  void _setupPaymentStatusListener() {
    // Assuming you have a stream method in PaymentSetupFirestore
    // Replace this with your actual stream method
    _paymentStatusSubscription = PaymentSetupFirestore.getPaymentStatusStream(widget.uid, widget.ticketId).listen((isPay) {
      // Hanya show dialog jika screen masih aktif dan dialog belum pernah ditunjukkan
      if (isPay == true && _isScreenActive && !_isDialogShown && mounted) {
        _showPaymentSuccessDialog();
      }
    });
  }

  void _showPaymentSuccessDialog() {
    if (!mounted || _isDialogShown) return; // Double check sebelum show dialog

    _isDialogShown = true; // Set flag untuk prevent duplicate dialog

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.localization.paymentSuccess),
          content: Text(context.localization.paymentSuccessDialogDescription),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                if (mounted) {
                  context.pop(); // Navigate back
                }
              },
              child: Text(context.localization.close),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Set screen sebagai tidak aktif
    _isScreenActive = false;

    // Cancel stream subscription
    _paymentStatusSubscription.cancel();

    // Dispose controllers and focus nodes
    _nameInput.dispose();
    _emailInput.dispose();
    _phoneInput.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: FutureBuilder(
            future: _fetchInvoice,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                _isFetchingInvoice = true;
              } else if (snapshot.hasData) {
                invoice = Invoice.fromMap(snapshot.data!);
                _isFetchingInvoice = false;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Skeletonizer(
                        enabled: _isFetchingInvoice,
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Text(
                                context.localization.totalAmount,
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _isFetchingInvoice == true ? 'RM 450.00' : 'RM ${invoice!.finalPrice.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 5,
                                children: [
                                  Icon(Icons.lock_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('Settings').doc('payment-gateway').snapshots(),
                                      builder: (context, asyncSnapshot) {
                                        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                          return Text(
                                            '---',
                                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                          );
                                        }

                                        if (asyncSnapshot.hasData) {
                                          var data = asyncSnapshot.data!.data() as Map<String, dynamic>;
                                          final paymentGateway = data['currentProviderId'];

                                          return Text(
                                            '${context.localization.securePayment} ${toBeginningOfSentenceCase(paymentGateway.toString())}',
                                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                          );
                                        }
                                        return Text(
                                          '${context.localization.securePayment} Saf Mobile',
                                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                        );
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: FutureBuilder(
                          future: _fetchCustomer,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              _isFetchingCustomer = true;
                            } else if (snapshot.hasData) {
                              if (_isFetchingCustomer == true) {
                                customer = Customer.fromMap(snapshot.data!);
                                _nameInput.text = customer!.name;
                                _phoneInput.text = customer!.phoneNumber;
                                if (customer!.email.contains(customer!.phoneNumber)) {
                                  _emailInput.text = '';
                                } else {
                                  _emailInput.text = customer!.email;
                                }
                              }

                              _isFetchingCustomer = false;
                            }
                            return Skeletonizer(
                              enabled: _isFetchingCustomer,
                              child: SingleChildScrollView(
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                child: Form(
                                  key: _formkey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          controller: _nameInput,
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _nameFocusNode,
                                          onTapOutside: (event) => _nameFocusNode.unfocus(),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return context.localization.nameError;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: context.localization.name,
                                            hintText: 'Abdullah',
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        TextFormField(
                                          controller: _phoneInput,
                                          keyboardType: TextInputType.phone,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _phoneFocusNode,
                                          onTapOutside: (event) => _phoneFocusNode.unfocus(),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return context.localization.phoneNumberError;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: context.localization.phoneNumber,
                                            hintText: '0123456789',
                                            prefixIcon: Icon(Icons.phone),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        TextFormField(
                                          controller: _emailInput,
                                          keyboardType: TextInputType.emailAddress,
                                          textInputAction: TextInputAction.done,
                                          focusNode: _emailFocusNode,
                                          onTapOutside: (event) => _emailFocusNode.unfocus(),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return context.localization.emailError;
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            hintText: 'abdullah@email.com',
                                            prefixIcon: Icon(Icons.email),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Consumer<PaymentProvider>(builder: (context, paymentProvider, child) {
                                          return Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: SizedBox(
                                                width: 400,
                                                height: 60,
                                                child: FilledButton(
                                                  onPressed: paymentProvider.isLoadingApi == true
                                                      ? null
                                                      : () async => PaymentHelper().choosePaymentMethod(
                                                            context: context,
                                                            formKey: _formkey,
                                                            paymentProvider: paymentProvider,
                                                            ticketId: widget.ticketId,
                                                            uid: widget.uid,
                                                            name: _nameInput.text,
                                                            phone: _phoneInput.text,
                                                            email: _emailInput.text,
                                                            amount: invoice?.finalPrice ?? 0,
                                                          ),
                                                  child: Text(context.localization.continueText),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                            child: SizedBox(
                                              width: 400,
                                              height: 60,
                                              child: FilledButton(
                                                onPressed: () => context.pop(),
                                                style: ButtonStyle(
                                                  backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainer),
                                                  foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onSurface),
                                                ),
                                                child: Text(context.localization.cancel),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
