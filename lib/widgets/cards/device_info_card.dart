import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/jobsheet.dart';

class DeviceInfoCard extends StatefulWidget {
  final String ticketId;
  final Jobsheet jobsheet;
  final Stream customerStream;
  const DeviceInfoCard({super.key, required this.jobsheet, required this.ticketId, required this.customerStream});

  @override
  State<DeviceInfoCard> createState() => _DeviceInfoCardState();
}

class _DeviceInfoCardState extends State<DeviceInfoCard> {
  String _pickupDate(Jobsheet jobsheet) {
    return Jiffy.parseFromDateTime(jobsheet.pickupDate.toDate()).format(pattern: 'dd MMM yyyy');
  }

  String _estimateDone(Jobsheet jobsheet) {
    return Jiffy.parseFromDateTime(jobsheet.estimateDone.toDate()).format(pattern: 'dd MMM yyyy');
  }

  IconData _profileIcon(int i) {
    switch (i) {
      case 0:
        return Icons.watch_later;
      case 1:
        return Icons.search;
      case 2:
        return Icons.construction;
      case 3:
        return Icons.checklist_rtl;
      case 4:
        return Icons.verified_outlined;
      case 5:
        return Icons.verified_outlined;
      default:
        return Icons.h_mobiledata;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Card.outlined(
        surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 10,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: StreamBuilder(
                    stream: widget.customerStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        const Text(
                          'Fetching data..',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        );
                      } else {
                        final Customer customer = Customer.fromMap(snapshot.data!);
                        return Text(
                          '${customer.name} (${widget.ticketId.toString()})',
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        );
                      }
                      return Text(
                        widget.ticketId.toString(),
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      );
                    }),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 28,
                      child: Icon(widget.jobsheet.returnPosition != null
                          ? Icons.warning
                          : _profileIcon(
                              widget.jobsheet.progressStep,
                            )),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.jobsheet.modelName} (${widget.jobsheet.colour})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(widget.jobsheet.problem),
                        Text('RM${widget.jobsheet.estimatePrice.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      'Tarikh terima: ',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      'Anggaran siap: ',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      _pickupDate(widget.jobsheet),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      _estimateDone(widget.jobsheet),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
