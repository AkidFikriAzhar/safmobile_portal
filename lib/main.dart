import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/controllers/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme(); // ✅ Load theme sebelum run app
  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'Saf Mobile Portal',
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
