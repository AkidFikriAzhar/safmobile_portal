import 'package:flutter/material.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/theme_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Saf Mobile Portal',
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
