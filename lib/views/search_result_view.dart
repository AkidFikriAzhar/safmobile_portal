import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/routes.dart';

class ViewSearchResult extends StatelessWidget {
  final String? ticketId;
  const ViewSearchResult({super.key, this.ticketId});

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
    );
  }
}
