import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/model/invoice.dart';

class WarrantyDetails extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> invoiceItemStream;
  final Invoice invoice;
  final Function(List<InvoiceItem>) onItemsLoaded;
  const WarrantyDetails(
      {super.key,
      required this.invoice,
      required this.invoiceItemStream,
      required this.onItemsLoaded});

  @override
  State<WarrantyDetails> createState() => _WarrantyDetailsState();
}

class _WarrantyDetailsState extends State<WarrantyDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.invoiceItemStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 10),
                  Text(context.localization.loading),
                ],
              ),
            );
          } else if (snapshot.data == null || !snapshot.hasData) {
            return SizedBox();
          } else {
            final List<InvoiceItem> items = snapshot.data!.docs
                .map((e) => InvoiceItem.fromJson(e.data()))
                .toList();

            return Card.outlined(
              surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
              elevation: 2,
              shadowColor: Colors.transparent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final parts = items[index];
                    return ListTile(
                      title: Text(parts.itemName),
                    );
                  },
                ),
              ),
            );
          }
        });
  }
}
