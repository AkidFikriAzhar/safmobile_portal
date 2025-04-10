import 'package:flutter/material.dart';

class ViewInvoices extends StatelessWidget {
  final String? uid;
  final String? ticketId;
  const ViewInvoices({super.key, this.uid, this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoices Information')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'User Informations',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
