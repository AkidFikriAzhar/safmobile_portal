import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/provider/theme_data.dart';
import 'package:safmobile_portal/widgets/dialogs/change_language.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.about),
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            tooltip: context.localization.theme,
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
            tooltip: context.localization.changeLanguage,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ChangeLanguageDialog(),
              );
            },
            icon: Icon(Icons.language_outlined),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${context.localization.aboutDescription}\n\n',
                      ),
                      TextSpan(
                        text: '${context.localization.goalTitle}\n\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      // TextSpan(text: '${context.localization.goalIntro}\n'),
                      TextSpan(text: '${context.localization.goal1Bold}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${context.localization.goal1} \n'),
                      TextSpan(text: '${context.localization.goal2Bold}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${context.localization.goal2} \n'),
                      TextSpan(text: '${context.localization.goal3Bold}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${context.localization.goal3} \n\n'),
                      // T
                      TextSpan(
                        text: '${context.localization.featuresTitle}\n\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '${context.localization.feature1Title}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${context.localization.feature1Desc}\n'),
                      TextSpan(text: '${context.localization.feature2Title}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${context.localization.feature2Desc}\n'),
                      TextSpan(text: '${context.localization.feature3Title}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${context.localization.feature3Desc}\n\n'),
                      TextSpan(
                        text: '${context.localization.whoShouldUseTitle}\n\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '${context.localization.whoShouldUseDesc}\n\n',
                      ),
                      TextSpan(
                        text: '${context.localization.techTitle}\n\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '${context.localization.techDesc}\n',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                    },
                    icon: const Icon(Icons.double_arrow_outlined),
                    label: Text(context.localization.useSafMobileNow),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${context.localization.version} 1.5.8\nAkid Fikri Azhar • TheKampungKod </>',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
