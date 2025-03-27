import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.receipt_long),
                    labelText: 'Ticket ID',
                    hintText: 'Enter ticket ID',
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: FilledButton.icon(
                        onPressed: () {
                          context.pushNamed(Routes.invoices);
                        },
                        label: const Text('Search'),
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          context.pushNamed(Routes.invoices);
                        },
                        label: const Text('Scan QR'),
                        icon: const Icon(Icons.qr_code_scanner),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
