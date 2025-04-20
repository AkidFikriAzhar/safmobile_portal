import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/controllers/service_order_provider.dart';
import 'package:safmobile_portal/controllers/theme_data.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/model/jobsheet.dart';
import 'package:safmobile_portal/services/service_order_firestore.dart';
import 'package:safmobile_portal/widgets/dialogs/change_language.dart';
import 'package:safmobile_portal/widgets/pageview/device_info_pageview.dart';
import 'package:safmobile_portal/widgets/pageview/repair_status_pageview.dart';

class ServiceOrderView extends StatefulWidget {
  final String? uid;
  final String? ticketId;
  const ServiceOrderView({super.key, required this.ticketId, required this.uid});

  @override
  State<ServiceOrderView> createState() => _ServiceOrderViewState();
}

class _ServiceOrderViewState extends State<ServiceOrderView> {
  late Stream<DocumentSnapshot> _serviceOrderStream;
  late Stream<DocumentSnapshot> _customerStream;
  final PageController _page = PageController();

  @override
  void initState() {
    _serviceOrderStream = ServiceOrderFirestore().getServiceOrderStream(widget.uid.toString(), widget.ticketId.toString());
    _customerStream = ServiceOrderFirestore().getCustomer(widget.uid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final serviceOrderProvider = Provider.of<ServiceOrderProvider>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: _serviceOrderStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 10),
                  Text(context.localization.loading),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.browser_not_supported_outlined, size: 60, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('No data found!'),
                ],
              ),
            ),
          );
        } else {
          final Jobsheet jobsheet = Jobsheet.fromMap(snapshot.data!);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Service Order'),
              // bottom: PreferredSize(
              //   preferredSize: Size.fromHeight(200),

              // ),
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: MaterialSegmentedControl(
                      selectionIndex: serviceOrderProvider.currentStep,
                      borderColor: Theme.of(context).colorScheme.outline,
                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      selectedTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      unselectedColor: Theme.of(context).colorScheme.onInverseSurface.withValues(alpha: 0.1),
                      unselectedTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                      borderWidth: 1.5,
                      onSegmentTapped: (value) {
                        serviceOrderProvider.setCurrentStep(value);
                        _page.animateToPage(
                          value,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      children: {
                        0: Text('General Information'),
                        1: Text('Repair Status'),
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView(
                    onPageChanged: (value) {
                      serviceOrderProvider.setCurrentStep(value);
                    },
                    controller: _page,
                    children: [
                      DeviceInfoPageview(ticketId: widget.ticketId.toString(), jobsheet: jobsheet, customerStream: _customerStream),
                      RepairStatusPageview(jobsheet: jobsheet),
                    ],
                  ),
                ),
              ],
            ),
            //     }),
          );
        }
      },
    );
  }
}
