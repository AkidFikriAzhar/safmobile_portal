import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentView extends StatelessWidget {
  final String uid;
  final String ticketId;
  const PaymentView({super.key, required this.uid, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
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
                      'RM 450.00',
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
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Contact Information',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Abdullah',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'abdullah@email.com',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: '0123456789',
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(
                                width: 400,
                                height: 60,
                                child: FilledButton(
                                  onPressed: () {},
                                  child: Text('Continue'),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(
                                width: 400,
                                height: 60,
                                child: FilledButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainer),
                                    foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onSurface),
                                  ),
                                  child: Text('Cancel'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: SizedBox(
                              width: 600,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 15,
                                  children: [
                                    Checkbox(
                                      value: true,
                                      onChanged: (bool? value) {},
                                    ),
                                    Expanded(
                                      child: Text(
                                        'By clicking the \'Continue\', you confirm that you have read and agree to our Terms & Conditions',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
