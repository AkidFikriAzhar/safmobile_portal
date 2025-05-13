import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/helpers/payment_helper.dart';
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/services/payment_setup_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  final _formkey = GlobalKey<FormState>();

  late Future _fetchInvoice;
  late Future _fetchCustomer;
  Invoice? invoice;
  Customer? customer;

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
    super.initState();
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
                                'Total amount',
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
                                  Text(
                                    'Secure Payment',
                                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                  ),
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
                                              return 'Please enter your name';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Name',
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
                                              return 'Please enter your phone number';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
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
                                              return 'Please enter your email';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
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
                                                  child: Text('Continue'),
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
                                                child: Text('Cancel'),
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
