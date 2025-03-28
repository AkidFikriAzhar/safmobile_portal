import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/controllers/theme_data.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: 50,
        child: Center(
          child: Text(
            'Assaff Enterprise 2025 © All Rights Reserved',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Themes',
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
            tooltip: 'Language',
            onPressed: () {},
            icon: Icon(Icons.language_outlined),
          ),
          IconButton(
            tooltip: 'Help',
            onPressed: () {},
            icon: Icon(Icons.help_outline),
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
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark ? 'assets/images/logo_dark.png' : 'assets/images/logo_light.png',
                    width: 70,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Check Your Invoice or Service Order Status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
