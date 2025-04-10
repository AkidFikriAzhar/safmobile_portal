import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/controllers/search_provider.dart';
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 15),
                  Text("Loading data..."),
                ],
              ),
            );
          } else if (provider.results.isEmpty) {
            return const Center(child: Text("No records found"));
          } else {
            return ListView.builder(
              itemCount: provider.results.length,
              itemBuilder: (context, index) {
                final item = provider.results[index];

                return ListTile(
                  title: Text(
                    item.isInvoice ? "Invoice - ${item.invoice!.id}" : "Service Order - ${item.jobsheet!.ticketId}",
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
