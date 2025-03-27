import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Themes',
            onPressed: () {},
            icon: Icon(Icons.dark_mode),
          ),
          IconButton(
            tooltip: 'Language',
            onPressed: () {},
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 800,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Check Your Invoice or Service Order Status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 45),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.receipt_long),
                      labelText: 'Ticket ID',
                      hintText: 'Enter ticket ID',
                    ),
                  ),
                  const SizedBox(height: 45),
                  SizedBox(
                    height: 45,
                    width: 250,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.pushNamed(Routes.invoices);
                      },
                      label: const Text('Search'),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: TextButton.icon(
                      onPressed: () {},
                      label: Text('Scan QR'),
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                  ),
                  // Wrap(
                  //   alignment: WrapAlignment.center,
                  //   runAlignment: WrapAlignment.center,
                  //   spacing: 15,
                  //   runSpacing: 15,
                  //   children: [
                  //     SizedBox(
                  //       height: 45,
                  //       width: 150,
                  //       child: FilledButton.icon(
                  //         onPressed: () {
                  //           context.pushNamed(Routes.invoices);
                  //         },
                  //         label: const Text('Search'),
                  //         icon: const Icon(Icons.search),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       height: 45,
                  //       width: 150,
                  //       child: FilledButton.tonalIcon(
                  //         onPressed: () {
                  //           context.pushNamed(Routes.invoices);
                  //         },
                  //         label: const Text('Scan QR'),
                  //         icon: const Icon(Icons.qr_code_scanner),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
