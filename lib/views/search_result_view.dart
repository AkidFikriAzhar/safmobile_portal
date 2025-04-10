import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/controllers/search_provider.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/routes.dart';

class ViewSearchResult extends StatefulWidget {
  final String? ticketId;
  const ViewSearchResult({super.key, this.ticketId});

  @override
  State<ViewSearchResult> createState() => _ViewSearchResultState();
}

class _ViewSearchResultState extends State<ViewSearchResult> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      final searchProvider = Provider.of<SearchProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Check if the widget is still mounted
          searchProvider.searchReference(widget.ticketId ?? '');
          setState(() {
            _hasFetched = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.searchResult),
        leading: IconButton(
          tooltip: context.localization.close,
          onPressed: () {
            context.goNamed(Routes.home);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: 50,
        child: Center(
          child: Text(
            '${context.localization.showingResult}: ${widget.ticketId}',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Consumer<SearchProvider>(builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator.adaptive(),
                  Text(context.localization.loading),
                ],
              ),
            );
          } else if (provider.results.isEmpty) {
            return Center(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_outlined, size: 45, color: Colors.grey),
                  Text(
                    context.localization.noResult,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.results.length,
              itemBuilder: (context, index) {
                final item = provider.results[index];

                return ListTile(
                  visualDensity: const VisualDensity(horizontal: 4),
                  leading: CircleAvatar(
                    child: Icon(
                      item.isInvoice ? Icons.receipt_long : Icons.assignment,
                    ),
                  ),
                  title: Text(
                    item.isInvoice
                        ? item.invoice!.isPay
                            ? context.localization.receipt
                            : context.localization.invoice
                        : "Service Order",
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.isInvoice
                          ? item.invoice!.isPay
                              ? context.localization.paymentMade
                              : context.localization.paymentNotMade
                          : item.jobsheet!.modelName),
                      const SizedBox(height: 2),
                      Text(
                        item.isInvoice
                            ? Jiffy.parseFromDateTime(item.invoice!.lastUpdate.toDate()).format(pattern: "dd MMM yyyy")
                            : Jiffy.parseFromDateTime(item.jobsheet!.pickupDate.toDate()).format(pattern: "dd MMM yyyy"),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Text('RM ${item.isInvoice ? item.invoice!.finalPrice.toStringAsFixed(2) : item.jobsheet!.estimatePrice.toStringAsFixed(2)}'),
                  onTap: () {},
                );
              },
            );
          }
        }),
      ),
    );
  }
}
