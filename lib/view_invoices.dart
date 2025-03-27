import 'package:flutter/material.dart';

class ViewInvoices extends StatelessWidget {
  const ViewInvoices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoices')),
      body: Center(
        child: Text('Invoices'),
      ),
    );
  }
}
