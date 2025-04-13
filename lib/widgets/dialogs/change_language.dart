import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/l10n/stream_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageDialog extends StatelessWidget {
  const ChangeLanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.language),
      title: Text(context.localization.changeLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'English',
              style: TextStyle(fontWeight: context.localization.localeName == 'en' ? FontWeight.bold : FontWeight.normal),
            ),
            onTap: () async {
              StreamLanguage.languageStream.add(const Locale('en'));

              Navigator.of(context).pop();
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await Jiffy.setLocale('en');
              prefs.setString('language', 'en');
            },
          ),
          ListTile(
            title: Text(
              'Bahasa Melayu',
              style: TextStyle(fontWeight: context.localization.localeName == 'ms' ? FontWeight.bold : FontWeight.normal),
            ),
            onTap: () async {
              StreamLanguage.languageStream.add(const Locale('ms'));
              Navigator.of(context).pop();
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await Jiffy.setLocale('ms');
              prefs.setString('language', 'ms');
            },
          ),
        ],
      ),
    );
  }
}
