import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WarrantyDetails extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> invoiceItemStream;
  final Invoice invoice;
  final Function(List<InvoiceItem>) onItemsLoaded;
  const WarrantyDetails({super.key, required this.invoice, required this.invoiceItemStream, required this.onItemsLoaded});

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
            return Card.outlined(
                surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
                elevation: 2,
                shadowColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                  child: Skeletonizer(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(context.localization.loading),
                        );
                      },
                    ),
                  ),
                ));
          } else if (snapshot.data == null || !snapshot.hasData) {
            return SizedBox();
          } else {
            final List<InvoiceItem> items = snapshot.data!.docs.map((e) => InvoiceItem.fromJson(e.data())).toList().where((element) => !element.itemName.contains('Discount')).toList();
            return items.isEmpty
                ? SizedBox()
                : Card.outlined(
                    surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
                    elevation: 2,
                    shadowColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.localization.warrantyDetails,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final parts = items[index];
                              final now = DateTime.now();
                              final totalDays = parts.warrantyEnd!.toDate().difference(parts.warrantyStart!.toDate()).inDays;
                              int remainingDays = parts.warrantyEnd!.toDate().difference(now).inDays + 1;
                              final warrantyDuration =
                                  '${Jiffy.parseFromDateTime(parts.warrantyStart!.toDate()).format(pattern: 'dd/MM/yyyy')} - ${Jiffy.parseFromDateTime(parts.warrantyEnd!.toDate()).format(pattern: 'dd/MM/yyyy')}';
                              final isExpired = remainingDays < 0;
                              double progress = isExpired ? 1.0 : (remainingDays / totalDays).clamp(0.0, 1.0);
                              return ListTile(
                                isThreeLine: true,
                                leading: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    CircleAvatar(
                                      radius: 20,
                                      child: Text('${index + 1}'),
                                    ),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${parts.itemName} (${totalDays + 1} ${context.localization.days})'),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: isExpired == false ? 5 : 0,
                                  children: [
                                    isExpired == false ? LinearProgressIndicator(value: progress) : const SizedBox(),
                                    Text(
                                      isExpired == false
                                          ? '$remainingDays ${context.localization.daysRemaining} ($warrantyDuration)'
                                          : '${context.localization.warrantyExpired} ${remainingDays.abs()} ${context.localization.daysAgo} ($warrantyDuration)',
                                      style: TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
          }
        });
  }
}
