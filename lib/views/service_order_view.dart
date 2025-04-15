import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/controllers/service_order_provider.dart';
import 'package:safmobile_portal/controllers/theme_data.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/jobsheet.dart';
import 'package:safmobile_portal/services/service_order_firestore.dart';
import 'package:safmobile_portal/widgets/dialogs/change_language.dart';

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

  String _pickupDate(Jobsheet jobsheet) {
    return Jiffy.parseFromDateTime(jobsheet.pickupDate.toDate()).format(pattern: 'dd MMM yyyy');
  }

  String _estimateDone(Jobsheet jobsheet) {
    return Jiffy.parseFromDateTime(jobsheet.estimateDone.toDate()).format(pattern: 'dd MMM yyyy');
  }

  IconData _profileIcon(int i) {
    switch (i) {
      case 0:
        return Icons.watch_later;
      case 1:
        return Icons.search;
      case 2:
        return Icons.construction;
      case 3:
        return Icons.checklist_rtl;
      case 4:
        return Icons.verified_outlined;
      case 5:
        return Icons.verified_outlined;
      default:
        return Icons.h_mobiledata;
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Order'),
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
      body: StreamBuilder<DocumentSnapshot>(
          stream: _serviceOrderStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 10),
                    Text(context.localization.loading),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    const Icon(Icons.browser_not_supported_outlined, size: 30),
                    const SizedBox(height: 10),
                    Text('No data found!'),
                  ],
                ),
              );
            } else {
              final Jobsheet jobsheet = Jobsheet.fromMap(snapshot.data!);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 600,
                          child: Card.outlined(
                            surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
                            elevation: 10,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: StreamBuilder(
                                        stream: _customerStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            const Text(
                                              'Fetching data..',
                                              style: TextStyle(color: Colors.grey, fontSize: 10),
                                            );
                                          } else {
                                            final Customer customer = Customer.fromMap(snapshot.data!);
                                            return Text(
                                              '${customer.name} (${widget.ticketId.toString()})',
                                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                                            );
                                          }
                                          return Text(
                                            widget.ticketId.toString(),
                                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                                          );
                                        }),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: CircleAvatar(
                                          radius: 28,
                                          child: Icon(jobsheet.returnPosition != null
                                              ? Icons.warning
                                              : _profileIcon(
                                                  jobsheet.progressStep,
                                                )),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${jobsheet.modelName} (${jobsheet.colour})',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            Text(jobsheet.problem),
                                            Text('RM${jobsheet.estimatePrice.toStringAsFixed(2)}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: FittedBox(
                                        child: EasyStepper(
                                          disableScroll: true,
                                          activeStepTextColor: Theme.of(context).colorScheme.inverseSurface,
                                          finishedStepTextColor: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: .5),
                                          unreachedStepTextColor: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.5),
                                          unreachedStepBorderColor: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.5),
                                          activeStepBackgroundColor: jobsheet.returnPosition != null ? Colors.red : Theme.of(context).colorScheme.tertiary,
                                          activeStepIconColor: Theme.of(context).colorScheme.onTertiary,
                                          finishedStepBackgroundColor: Theme.of(context).colorScheme.primary,
                                          finishedStepIconColor: Theme.of(context).colorScheme.primaryContainer,
                                          activeStep: jobsheet.progressStep,
                                          steppingEnabled: false,
                                          internalPadding: 0,
                                          stepRadius: 15,
                                          showLoadingAnimation: false,
                                          showStepBorder: false,
                                          steps: [
                                            const EasyStep(
                                              enabled: false,
                                              icon: Icon(Icons.watch_later_outlined),
                                              finishIcon: Icon(Icons.done),
                                              title: 'Pending',
                                            ),
                                            EasyStep(
                                              enabled: false,
                                              icon: Icon(jobsheet.returnPosition == 1 ? Icons.search : Icons.search_outlined),
                                              finishIcon: const Icon(Icons.done),
                                            ),
                                            EasyStep(
                                              enabled: false,
                                              icon: Icon(jobsheet.returnPosition == 2 ? Icons.warning_outlined : Icons.construction_outlined),
                                              finishIcon: const Icon(Icons.done),
                                            ),
                                            EasyStep(
                                              enabled: false,
                                              icon: Icon(jobsheet.returnPosition == 3 ? Icons.warning_outlined : Icons.checklist_rtl_rounded),
                                              finishIcon: const Icon(Icons.done),
                                            ),
                                            EasyStep(
                                              enabled: false,
                                              icon: Icon(jobsheet.returnPosition == 4 ? Icons.warning_outlined : Icons.verified_outlined),
                                              title: 'Done',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          'Tarikh terima: ',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          'Anggaran siap: ',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          _pickupDate(jobsheet),
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          _estimateDone(jobsheet),
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
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
                              0: Text('Repair Status'),
                              1: Text('General Information'),
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10000,
                          width: 600,
                          child: PageView(
                            onPageChanged: (value) {
                              serviceOrderProvider.setCurrentStep(value);
                            },
                            controller: _page,
                            children: [
                              repairStatus(jobsheet),
                              Text('Details'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget repairStatus(Jobsheet jobsheet) {
    return SizedBox(
      width: 600,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stepper(
            steps: [
              Step(
                title: Text('Pending'),
                content: Text('Yahah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
