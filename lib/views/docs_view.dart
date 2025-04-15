import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/controllers/document_provider.dart';
import 'package:safmobile_portal/controllers/theme_data.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/model/payment_method.dart';
import 'package:safmobile_portal/model/technician.dart';
import 'package:safmobile_portal/services/docs_firestore.dart';
import 'package:safmobile_portal/pdf/invoice_pdf.dart';
import 'package:safmobile_portal/widgets/dialogs/change_language.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DocsView extends StatefulWidget {
  final String? uid;
  final String? ticketId;
  const DocsView({super.key, this.uid, this.ticketId});

  @override
  State<DocsView> createState() => _DocsViewState();
}

class _DocsViewState extends State<DocsView> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _invoiceStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _customerStream;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _invoiceItemStream;
  Customer? customerLate;
  List<InvoiceItem>? invItems;
  Technician? technicianLate;

  @override
  void initState() {
    _invoiceStream = DocsFirestore().getDocsStream(widget.uid.toString(), widget.ticketId.toString());
    _customerStream = DocsFirestore().getCustomerStream(widget.uid.toString());
    _invoiceItemStream = DocsFirestore().getInvoiceItem(widget.uid.toString(), widget.ticketId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final docsProvider = Provider.of<DocumentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
            stream: _invoiceStream,
            builder: (context, snapshot) {
              final isFetched = snapshot.connectionState == ConnectionState.waiting;
              if (snapshot.hasData) {
                final Invoice invoice = Invoice.fromMap(snapshot.data!);
                return Skeletonizer(
                  enabled: isFetched,
                  child: Text(invoice.isPay == false ? context.localization.invoice : context.localization.receipt),
                );
              } else {
                return Text('Documents');
              }
            }),
        actions: [
          IconButton(
            tooltip: context.localization.theme,
            onPressed: () {
              setState(() {
                themeProvider.toggleTheme();
              });
            },
            icon: Icon(
              Icons.dark_mode,
              color: themeProvider.isDarkMode ? Colors.amber : Colors.black,
            ),
          ),
          IconButton(
            tooltip: context.localization.changeLanguage,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ChangeLanguageDialog(),
              );
            },
            icon: Icon(Icons.language_outlined),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _invoiceStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 10),
                    Text(context.localization.loading),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50),
                    const SizedBox(height: 10),
                    Text('Error: ${snapshot.error}'),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'No data available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              final Invoice invoice = Invoice.fromMap(snapshot.data!.data()!);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 600,
                            child: Card.outlined(
                              surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
                              elevation: 2,
                              shadowColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Consumer<DocumentProvider>(builder: (contex, provider, child) {
                                              // return Text('Billing ${provider.totalBilling} Items');
                                              return Text(context.localization.billingItem(provider.totalBilling));
                                            }),
                                            Text(
                                              '#${widget.ticketId}',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: invoice.isPay == true ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                          ),
                                          child: Text(
                                            invoice.isPay == true ? context.localization.paid : context.localization.unpaid,
                                            style: TextStyle(color: invoice.isPay == true ? Colors.green : Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        context.localization.customerInfo,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    StreamBuilder<DocumentSnapshot>(
                                        stream: _customerStream,
                                        builder: (context, snapshot) {
                                          bool isFetching = snapshot.connectionState == ConnectionState.waiting;

                                          if (snapshot.hasData) {
                                            final Customer customer = Customer.fromMap(snapshot.data!.data()!);
                                            customerLate = customer;
                                            return Skeletonizer(
                                              enabled: isFetching,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 28,
                                                    child: Icon(Icons.person_outline_outlined),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          isFetching ? 'Muhammad Aqif Syafi' : customer.name,
                                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                          isFetching ? '01111796421' : customer.phoneNumber,
                                                        ),
                                                        Text(
                                                          isFetching ? 'Kajang' : customer.location,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return Container();
                                        }),
                                    const SizedBox(height: 25),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        context.localization.technicianInfo,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TechnicianInformation(techId: invoice.techId),
                                    const SizedBox(height: 25),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          runAlignment: WrapAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(context.localization.issued),
                                                  Text(
                                                    Jiffy.parseFromDateTime(invoice.startDate.toDate()).format(pattern: 'dd/MM/yyyy'),
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(context.localization.due),
                                                  Text(
                                                    Jiffy.parseFromDateTime(invoice.dueDate.toDate()).format(pattern: 'dd/MM/yyyy'),
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot>(
                          stream: _invoiceItemStream,
                          builder: (context, snapshotItem) {
                            if (snapshotItem.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator.adaptive(),
                                    const SizedBox(height: 10),
                                    Text(context.localization.loading),
                                  ],
                                ),
                              );
                            } else if (snapshotItem.data == null) {
                              return Container();
                            } else if (snapshotItem.hasData) {
                              final List<InvoiceItem> items = (snapshotItem.data as QuerySnapshot).docs.map((e) => InvoiceItem.fromJson(e.data() as Map<String, dynamic>)).toList();
                              invItems = items;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Provider.of<DocumentProvider>(context, listen: false).incrementBilling(items.length);
                              });

                              double total = 0;
                              for (var item in items) {
                                total += item.itemPrice;
                                if (item.itemName == 'Discount') {
                                  total -= item.itemPrice;
                                }
                              }
                              return SizedBox(
                                width: 600,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card.outlined(
                                      surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
                                      elevation: 2,
                                      shadowColor: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(2),
                                                1: FlexColumnWidth(0.9),
                                                2: FlexColumnWidth(0.7),
                                              },
                                              children: [
                                                TableRow(
                                                  children: [
                                                    TableCell(
                                                        child: Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                                      child: const Text('Item'),
                                                    )),
                                                    TableCell(
                                                        child: Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Text(context.localization.warranty),
                                                    )),
                                                    TableCell(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Text(context.localization.price),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                for (var item in items)
                                                  TableRow(
                                                    children: [
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                          child: Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                          child: Text(warrantyDur(item), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                        ),
                                                      ),
                                                      TableCell(
                                                          child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                        child: Text(item.itemPrice.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                      )),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(context.localization.total, style: TextStyle(fontSize: 14)),
                                                      Text(
                                                        'RM ${total.toStringAsFixed(2)}',
                                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(context.localization.discount, style: TextStyle(fontSize: 14)),
                                                      Text(
                                                        'RM ${invoice.discount.toStringAsFixed(2)}',
                                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  invoice.isPay == true
                                                      ? Column(
                                                          children: [
                                                            const SizedBox(height: 5),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(context.localization.paymentMethod, style: TextStyle(fontSize: 14)),
                                                                Text(
                                                                  invoice.paymentMethod.displayName,
                                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  const SizedBox(height: 15),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.primaryContainer,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: ListTile(
                                                      visualDensity: const VisualDensity(vertical: 1),
                                                      title: Text(
                                                        context.localization.amount,
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        'RM ${invoice.finalPrice.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                      invoice.isPay == true ? const SizedBox() : const SizedBox(height: 10),
                      invoice.isPay == true
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 300,
                                height: 60,
                                child: FilledButton.icon(
                                  onPressed: () {},
                                  label: Text(context.localization.payNow),
                                  icon: Icon(Icons.payments),
                                ),
                              ),
                            ),
                      const SizedBox(height: 1),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 300,
                          height: 60,
                          child: TextButton.icon(
                            onPressed: () async {
                              final file = await PdfInvoice.generatePdf(
                                customer: customerLate as Customer,
                                invoice: invoice,
                                technician: docsProvider.technicianLate as Technician,
                                invoiceItems: invItems as List<InvoiceItem>,
                              );

                              PdfInvoice.savePDF(file, invoice.isPay, invoice.id.toString());
                            },
                            label: Text(context.localization.downloadPdf),
                            icon: Icon(Icons.download),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  String warrantyDur(InvoiceItem item) {
    final String dur = Jiffy.parseFromDateTime(item.warrantyEnd!.toDate()).from(Jiffy.parseFromDateTime(item.warrantyStart!.toDate()), withPrefixAndSuffix: false);

    if (dur == '0 seconds') {
      return '--';
    }
    if (dur == 'a few seconds') {
      return '--';
    }

    return dur;
  }
}

class TechnicianInformation extends StatefulWidget {
  final String techId;
  const TechnicianInformation({super.key, required this.techId});

  @override
  State<TechnicianInformation> createState() => _TechnicianInformationState();
}

class _TechnicianInformationState extends State<TechnicianInformation> {
  late Stream<DocumentSnapshot> _technicianStream;

  @override
  void initState() {
    _technicianStream = DocsFirestore().getTechnicianStream(widget.techId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final docsProvider = Provider.of<DocumentProvider>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: _technicianStream,
        builder: (context, snapshot) {
          final isFetched = snapshot.connectionState == ConnectionState.waiting;
          if (snapshot.hasData) {
            final Technician technician = Technician.fromMap(snapshot.data!);
            docsProvider.technicianLate = technician;
            return Skeletonizer(
              enabled: isFetched,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person_4_outlined),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isFetched ? 'Akid Fikri Azhar' : technician.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isFetched ? 'Chief Technician Officer' : technician.jawatan,
                        ),
                        Text(
                          isFetched ? 'Saf Mobile Express - Sungai Ramal Luar' : technician.branchText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
