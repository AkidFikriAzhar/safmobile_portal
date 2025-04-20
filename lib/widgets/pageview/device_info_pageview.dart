import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pattern_dots/pattern_dots.dart';
import 'package:safmobile_portal/model/firestore_references.dart';
import 'package:safmobile_portal/model/jobsheet.dart';
import 'package:safmobile_portal/widgets/cards/device_info_card.dart';

class DeviceInfoPageview extends StatefulWidget {
  final String ticketId;
  final Jobsheet jobsheet;
  final Stream customerStream;
  const DeviceInfoPageview({super.key, required this.ticketId, required this.jobsheet, required this.customerStream});

  @override
  State<DeviceInfoPageview> createState() => _DeviceInfoPageviewState();
}

class _DeviceInfoPageviewState extends State<DeviceInfoPageview> {
  @override
  Widget build(BuildContext context) {
    final String pickupDate = Jiffy.parseFromDateTime(widget.jobsheet.pickupDate.toDate()).format(pattern: 'dd/MM/yyyy (HH:mm:ss)');
    final String estimateDone = Jiffy.parseFromDateTime(widget.jobsheet.estimateDone.toDate()).from(Jiffy.parseFromDateTime(widget.jobsheet.pickupDate.toDate()));
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            DeviceInfoCard(jobsheet: widget.jobsheet, ticketId: widget.ticketId.toString(), customerStream: widget.customerStream),
            const SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                // border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      _info('Receive date: ', pickupDate),
                      _info('Estiamte resolved: ', estimateDone),
                    ],
                  ),
                  TableRow(
                    children: [
                      _info('Device Model: ', widget.jobsheet.modelName),
                      _info('Device Colour: ', widget.jobsheet.colour),
                    ],
                  ),
                  TableRow(
                    children: [
                      _info('Device\'s imei: ', widget.jobsheet.imei!),
                      _info('Ticket ID: ', widget.jobsheet.ticketId.toString()),
                    ],
                  ),
                  TableRow(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection(FirestoreReferences.customer).doc(widget.jobsheet.ownerID).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _info('Customer: ', 'Loading...');
                            }
                            return _info('Customer: ', snapshot.data!['name']);
                          }),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection(FirestoreReferences.technician).doc(widget.jobsheet.techID).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _info('Juruteknik: ', 'Memuatkan data...');
                            }
                            return _info('Juruteknik: ', snapshot.data!['name']);
                          }),
                    ],
                  ),
                  TableRow(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection(FirestoreReferences.branch).doc(widget.jobsheet.branchID).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _info('Drop-off branch: ', 'Loading data...');
                            }
                            return _info('Drop-off branch: ', snapshot.data!['name']);
                          }),
                      _info('Return Reason: ', widget.jobsheet.returnReason!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            subtitle.isEmpty ? '-' : subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
