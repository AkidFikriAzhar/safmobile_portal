import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/provider/document_provider.dart';
import 'package:safmobile_portal/provider/theme_data.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/extensions/route_extension.dart';
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/model/payment_method.dart';
import 'package:safmobile_portal/model/technician.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/services/docs_firestore.dart';
import 'package:safmobile_portal/pdf/invoice_pdf.dart';
import 'package:safmobile_portal/widgets/cards/docs_warranty_card.dart';
import 'package:safmobile_portal/widgets/dialogs/change_language.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DocsView extends StatefulWidget {
  final String? uid;
  final String? ticketId;
  const DocsView({super.key, this.uid, this.ticketId});

  @override
  State<DocsView> createState() => _DocsViewState();
}

class _DocsViewState extends State<DocsView> with AutomaticKeepAliveClientMixin {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _invoiceStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _customerStream;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _invoiceItemStream;

  // Cache data untuk mengurangkan rebuild
  Customer? _cachedCustomer;
  Invoice? _cachedInvoice;
  List<InvoiceItem>? _cachedInvoiceItems;
  Technician? _cachedTechnician;

  // Controller untuk optimized scrolling
  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeStreams();
  }

  void _initializeStreams() {
    _invoiceStream = DocsFirestore().getDocsStream(widget.uid.toString(), widget.ticketId.toString());
    _customerStream = DocsFirestore().getCustomerStream(widget.uid.toString());
    _invoiceItemStream = DocsFirestore().getInvoiceItem(widget.uid.toString(), widget.ticketId.toString());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: StreamBuilder<DocumentSnapshot>(
          stream: _invoiceStream,
          builder: (context, snapshot) {
            final isFetched = snapshot.connectionState == ConnectionState.waiting;
            if (snapshot.hasData && snapshot.data!.exists) {
              final Invoice invoice = Invoice.fromMap(snapshot.data!.data()!);
              _cachedInvoice = invoice; // Cache data
              return Skeletonizer(
                enabled: isFetched,
                child: Text(invoice.isPay == false ? context.localization.invoice : context.localization.receipt),
              );
            } else {
              return const Text('Documents');
            }
          }),
      actions: [
        _buildThemeToggle(context),
        _buildLanguageButton(context),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          tooltip: context.localization.theme,
          onPressed: () => themeProvider.toggleTheme(),
          icon: Icon(
            Icons.dark_mode,
            color: themeProvider.isDarkMode ? Colors.amber : Colors.black,
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return IconButton(
      tooltip: context.localization.changeLanguage,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const ChangeLanguageDialog(),
        );
      },
      icon: const Icon(Icons.language_outlined),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _invoiceStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _cachedInvoice == null) {
          return _buildLoadingState(context);
        } else if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildNoDataState();
        } else {
          final Invoice invoice = Invoice.fromMap(snapshot.data!.data()!);
          _cachedInvoice = invoice;
          return _buildMainContent(invoice);
        }
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
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
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50),
          const SizedBox(height: 10),
          Text('Error: $error'),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50),
          SizedBox(height: 10),
          Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  ///MAIN CONTENT///

  Widget _buildMainContent(Invoice invoice) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(), // Better performance than BouncingScrollPhysics
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _InvoiceHeaderCard(
                invoice: invoice,
                ticketId: widget.ticketId!,
                customerStream: _customerStream,
                onCustomerLoaded: (customer) => _cachedCustomer = customer,
              ),
              const SizedBox(height: 10),
              _InvoiceItemsSection(
                invoiceItemStream: _invoiceItemStream,
                invoice: invoice,
                onItemsLoaded: (items) => _cachedInvoiceItems = items,
              ),
              const SizedBox(height: 10),
              invoice.isPay == false
                  ? const SizedBox()
                  : WarrantyDetails(
                      invoiceItemStream: _invoiceItemStream,
                      invoice: invoice,
                      onItemsLoaded: (items) => _cachedInvoiceItems = items,
                    ),
              invoice.isPay == false ? const SizedBox(height: 10) : SizedBox(height: 20),
              _ActionButtons(
                invoice: invoice,
                onDownloadPdf: () => _handleDownloadPdf(invoice),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleDownloadPdf(Invoice invoice) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Generating PDF...'),
          ],
        ),
      ),
    );

    try {
      // Wait for all data to be available with timeout
      Customer? customer = _cachedCustomer;
      List<InvoiceItem>? invoiceItems = _cachedInvoiceItems;
      Technician? technician = _cachedTechnician;

      // If any data is missing, try to fetch directly
      if (customer == null) {
        final customerDoc = await DocsFirestore().getCustomerStream(widget.uid.toString()).first;
        if (customerDoc.exists) {
          customer = Customer.fromMap(customerDoc.data()!);
          _cachedCustomer = customer;
        }
      }

      if (invoiceItems == null) {
        final itemsQuery = await DocsFirestore().getInvoiceItem(widget.uid.toString(), widget.ticketId.toString()).first;
        invoiceItems = itemsQuery.docs.map((e) => InvoiceItem.fromJson(e.data())).toList();
        _cachedInvoiceItems = invoiceItems;
      }

      if (technician == null) {
        final techDoc = await DocsFirestore().getTechnicianStream(invoice.techId).first;
        if (techDoc.exists) {
          technician = Technician.fromMap(techDoc);
          _cachedTechnician = technician;
        }
      }

      // Final check
      if (customer == null || technician == null) {
        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to load all required data. Please try again.')),
        );
        return;
      }

      final file = await PdfInvoice.generatePdf(
        customer: customer,
        invoice: invoice,
        technician: technician,
        invoiceItems: invoiceItems,
      );
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      PdfInvoice.savePDF(file, invoice.isPay, invoice.id.toString());
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF generated successfully!')),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }
}

// Separate widgets untuk mengurangkan rebuild scope
class _InvoiceHeaderCard extends StatelessWidget {
  final Invoice invoice;
  final String ticketId;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> customerStream;
  final Function(Customer) onCustomerLoaded;

  const _InvoiceHeaderCard({
    required this.invoice,
    required this.ticketId,
    required this.customerStream,
    required this.onCustomerLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 2,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 10),
            _buildCustomerInfo(context),
            const SizedBox(height: 25),
            _buildTechnicianInfo(context),
            invoice.isPay == false ? const SizedBox(height: 25) : SizedBox(),
            invoice.isPay == false ? _buildInvoiceDateInfo(context) : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<DocumentProvider>(builder: (context, provider, child) {
              return Text(context.localization.billingItem(provider.totalBilling));
            }),
            Text(
              '#$ticketId',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }

  Widget _buildCustomerInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.localization.customerInfo,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<DocumentSnapshot>(
            stream: customerStream,
            builder: (context, snapshot) {
              bool isFetching = snapshot.connectionState == ConnectionState.waiting;

              if (snapshot.hasData && snapshot.data!.exists) {
                final Customer customer = Customer.fromMap(snapshot.data!.data()!);
                onCustomerLoaded(customer);
                return Skeletonizer(
                  enabled: isFetching,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
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
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(isFetching ? '01111796421' : customer.phoneNumber),
                            Text(isFetching ? 'Kajang' : customer.location),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
      ],
    );
  }

  Widget _buildTechnicianInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.localization.technicianInfo,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        _OptimizedTechnicianInformation(techId: invoice.techId),
      ],
    );
  }

  Widget _buildInvoiceDateInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        children: [
          Text(
            context.localization.invoiceDate,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceItemsSection extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> invoiceItemStream;
  final Invoice invoice;
  final Function(List<InvoiceItem>) onItemsLoaded;

  const _InvoiceItemsSection({
    required this.invoiceItemStream,
    required this.invoice,
    required this.onItemsLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: invoiceItemStream,
        builder: (context, snapshotItem) {
          if (snapshotItem.connectionState == ConnectionState.waiting) {
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
          } else if (snapshotItem.data == null || !snapshotItem.hasData) {
            return Container();
          } else {
            final List<InvoiceItem> items = snapshotItem.data!.docs.map((e) => InvoiceItem.fromJson(e.data() as Map<String, dynamic>)).toList();

            onItemsLoaded(items);

            // Use post frame callback to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<DocumentProvider>(context, listen: false).incrementBilling(items.length);
            });

            return Card.outlined(
              surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
              elevation: 2,
              shadowColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildItemsTable(context, items),
                    const SizedBox(height: 10),
                    _buildTotalSection(context, items),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _buildItemsTable(BuildContext context, List<InvoiceItem> items) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(0.9),
        2: FlexColumnWidth(0.7),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Item'),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(context.localization.warranty),
            )),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(context.localization.price),
              ),
            ),
          ],
        ),
        ...items.map((item) => TableRow(
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
                    child: Text(_getWarrantyDuration(item), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                TableCell(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(item.itemPrice.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                )),
              ],
            )),
      ],
    );
  }

  Widget _buildTotalSection(BuildContext context, List<InvoiceItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.itemPrice;
      if (item.itemName == 'Discount') {
        total -= item.itemPrice;
      }
    }

    return Container(
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
              Text(context.localization.total, style: const TextStyle(fontSize: 14)),
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
              Text(context.localization.discount, style: const TextStyle(fontSize: 14)),
              Text(
                'RM ${invoice.discount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          if (invoice.isPay == true) ...[
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.localization.paymentMethod, style: const TextStyle(fontSize: 14)),
                Text(
                  invoice.paymentMethod.displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ],
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
    );
  }

  String _getWarrantyDuration(InvoiceItem item) {
    if (item.warrantyStart == null || item.warrantyEnd == null) return '--';

    final String dur = Jiffy.parseFromDateTime(item.warrantyEnd!.toDate()).from(Jiffy.parseFromDateTime(item.warrantyStart!.toDate()), withPrefixAndSuffix: false);

    if (dur == '0 seconds' || dur == 'a few seconds') {
      return '--';
    }
    return dur;
  }
}

class _ActionButtons extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback onDownloadPdf;

  const _ActionButtons({
    required this.invoice,
    required this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (invoice.isPay == false) ...[
          SizedBox(
            width: 300,
            height: 60,
            child: FilledButton.icon(
              onPressed: () {
                final query = GoRouterState.of(context).pathParameters;
                context.goPush(Routes.payment, pathParameters: query);
              },
              label: Text(context.localization.payNow),
              icon: const Icon(Icons.payments),
            ),
          ),
          const SizedBox(height: 10),
        ],
        SizedBox(
          width: 300,
          height: 60,
          child: TextButton.icon(
            onPressed: onDownloadPdf,
            label: Text(context.localization.downloadPdf),
            icon: const Icon(Icons.download),
          ),
        ),
      ],
    );
  }
}

// Optimized Technician Information Widget
class _OptimizedTechnicianInformation extends StatefulWidget {
  final String techId;
  const _OptimizedTechnicianInformation({required this.techId});

  @override
  State<_OptimizedTechnicianInformation> createState() => __OptimizedTechnicianInformationState();
}

class __OptimizedTechnicianInformationState extends State<_OptimizedTechnicianInformation> with AutomaticKeepAliveClientMixin {
  late Stream<DocumentSnapshot> _technicianStream;
  Technician? _cachedTechnician;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _technicianStream = DocsFirestore().getTechnicianStream(widget.techId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<DocumentSnapshot>(
        stream: _technicianStream,
        builder: (context, snapshot) {
          final isFetched = snapshot.connectionState == ConnectionState.waiting;

          if (snapshot.hasData && snapshot.data!.exists) {
            final Technician technician = Technician.fromMap(snapshot.data!);
            _cachedTechnician = technician;

            // Update provider and cache technician data
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final docsProvider = Provider.of<DocumentProvider>(context, listen: false);
              docsProvider.technicianLate = technician;
              // Also update parent cache
              if (context.findAncestorStateOfType<_DocsViewState>() != null) {
                context.findAncestorStateOfType<_DocsViewState>()!._cachedTechnician = technician;
              }
            });

            return Skeletonizer(
              enabled: isFetched,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
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
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          } else if (_cachedTechnician != null) {
            // Use cached data while loading
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.person_4_outlined),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cachedTechnician!.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(_cachedTechnician!.jawatan),
                      Text(_cachedTechnician!.branchText),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
