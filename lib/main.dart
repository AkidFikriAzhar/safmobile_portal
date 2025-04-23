import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/provider/document_provider.dart';
import 'package:safmobile_portal/provider/home_provider.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';
import 'package:safmobile_portal/provider/search_provider.dart';
import 'package:safmobile_portal/provider/service_order_provider.dart';
import 'package:safmobile_portal/firebase_options.dart';
import 'package:safmobile_portal/l10n/l10n.dart';
import 'package:safmobile_portal/l10n/stream_language.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:safmobile_portal/provider/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:safmobile_portal/services/search_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme(); // ✅ Load theme sebelum run app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInAnonymously().then((val) {
    log('User ID: ${val.user?.uid}');
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider(SearchFirestore())),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (context) => ServiceOrderProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider())
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

void initSetup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String language = prefs.getString('language') ?? 'ms';

  StreamLanguage.languageStream.add(Locale(language));
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    initSetup();
    super.initState();
  }

  @override
  void dispose() {
    StreamLanguage.languageStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return StreamBuilder<Locale>(
        stream: StreamLanguage.languageStream.stream,
        builder: (context, snapshot) {
          return MaterialApp.router(
            title: 'Saf Mobile Portal',
            supportedLocales: L10n.locals,
            locale: snapshot.data,
            localizationsDelegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            routerConfig: Routes.router,
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        });
  }
}
