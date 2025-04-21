import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
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
  late Stream _branchStream;
  late Stream _technicianStream;

  @override
  void initState() {
    _branchStream = FirebaseFirestore.instance.collection(FirestoreReferences.branch).doc(widget.jobsheet.branchID).snapshots();
    _technicianStream = FirebaseFirestore.instance.collection(FirestoreReferences.technician).doc(widget.jobsheet.techID).snapshots();
    super.initState();
  }

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
                      _info('${context.localization.receivedDate}: ', pickupDate),
                      _info('${context.localization.estimatedDate}: ', estimateDone),
                    ],
                  ),
                  TableRow(
                    children: [
                      _info('${context.localization.deviceModel}: ', widget.jobsheet.modelName),
                      _info('${context.localization.deviceColour}: ', widget.jobsheet.colour),
                    ],
                  ),
                  TableRow(
                    children: [
                      _info('${context.localization.deviceImei}: ', widget.jobsheet.imei!),
                      _info('Ticket ID: ', widget.jobsheet.ticketId.toString()),
                    ],
                  ),
                  TableRow(
                    children: [
                      StreamBuilder(
                          stream: widget.customerStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _info('Customer: ', 'Loading...');
                            }
                            return _info('${context.localization.customerInfo}: ', snapshot.data!['name']);
                          }),
                      StreamBuilder(
                          stream: _technicianStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _info('${context.localization.technicianInfo}: ', 'Memuatkan data...');
                            }
                            return _info('${context.localization.technicianInfo}: ', snapshot.data!['name']);
                          }),
                    ],
                  ),
                  TableRow(
                    children: [
                      StreamBuilder(
                          stream: _branchStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _info('${context.localization.dropOffBranch}: ', 'Loading data...');
                            }
                            return _info('${context.localization.dropOffBranch}: ', snapshot.data!['name']);
                          }),
                      _info('${context.localization.returnReason}: ', widget.jobsheet.returnReason!),
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
