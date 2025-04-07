import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/controllers/search_provider.dart';
import 'package:safmobile_portal/routes.dart';

import '../model/invoice.dart';

class ViewSearchResult extends StatelessWidget {
  final String? ticketId;
  const ViewSearchResult({super.key, this.ticketId});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchProvider.searchReference(ticketId ?? '');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
        leading: IconButton(
          tooltip: 'Close',
          onPressed: () {
            context.goNamed(Routes.home);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<SearchProvider>(builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 15),
                  Text("Loading data..."),
                ],
              ),
            );
          } else if (provider.searchResult.isEmpty) {
            return Center(child: Text("No records found"));
          } else {
            return ListView.builder(
              itemCount: provider.searchResult.length,
              itemBuilder: (context, index) {
                final item = provider.searchResult[index];
                bool isInvoice = item is Invoice;
                return ListTile(
                  title: Text(
                    isInvoice ? "Invoice - ${item.id}" : "Service Order - ${item.ticketId}",
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
