import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/provider/search_provider.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/extensions/route_extension.dart';
import 'package:safmobile_portal/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ViewSearchResult extends StatefulWidget {
  final String? ticketId;
  const ViewSearchResult({super.key, this.ticketId});

  @override
  State<ViewSearchResult> createState() => _ViewSearchResultState();
}

class _ViewSearchResultState extends State<ViewSearchResult> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final searchProvider = Provider.of<SearchProvider>(context, listen: false);
          searchProvider.clear();
          searchProvider.searchReference(widget.ticketId ?? '');
          setState(() {
            _hasFetched = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.searchResult),
        leading: IconButton(
          tooltip: context.localization.close,
          onPressed: () {
            context.goNamed(Routes.home);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: 50,
        child: Center(
          child: Text(
            '${context.localization.showingResult}: ${widget.ticketId}',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          Widget content;
          if (provider.isLoading) {
            content = Skeletonizer(
              key: ValueKey('loading'),
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        duration: const Duration(milliseconds: 300),
                        child: FadeInAnimation(
                          duration: const Duration(milliseconds: 300),
                          child: ListTile(
                            visualDensity: const VisualDensity(horizontal: 4),
                            leading: const Icon(Icons.search, size: 40),
                            title: const Text("Service Order"),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Yahaha'),
                                const SizedBox(height: 2),
                                Text(
                                  '23 Jan 2024',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: Text('RM 450'),
                            onTap: () {},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (provider.results.isEmpty) {
            content = Center(
              key: ValueKey('empty'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_outlined, size: 45, color: Colors.grey),
                  Text(
                    context.localization.noResult,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            content = AnimationLimiter(
              child: ListView.builder(
                key: const ValueKey('list'),
                itemCount: provider.results.length,
                itemBuilder: (context, index) {
                  final item = provider.results[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      verticalOffset: 30.0,
                      duration: const Duration(milliseconds: 300),
                      child: FadeInAnimation(
                        duration: const Duration(milliseconds: 300),
                        child: ListTile(
                          visualDensity: const VisualDensity(horizontal: 4),
                          leading: CircleAvatar(
                            child: Icon(
                              item.isInvoice ? Icons.receipt_long : Icons.assignment,
                            ),
                          ),
                          title: Text(
                            item.isInvoice
                                ? item.invoice!.isPay
                                    ? context.localization.receipt
                                    : context.localization.invoice
                                : "Service Order",
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.isInvoice
                                  ? item.invoice!.isPay
                                      ? context.localization.paymentMade
                                      : context.localization.paymentNotMade
                                  : item.jobsheet!.modelName),
                              const SizedBox(height: 2),
                              Text(
                                item.isInvoice
                                    ? Jiffy.parseFromDateTime(item.invoice!.lastUpdate.toDate()).format(pattern: "dd MMM yyyy")
                                    : Jiffy.parseFromDateTime(item.jobsheet!.pickupDate.toDate()).format(pattern: "dd MMM yyyy"),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Text('RM ${item.isInvoice ? item.invoice!.finalPrice.toStringAsFixed(2) : item.jobsheet!.estimatePrice.toStringAsFixed(2)}'),
                          onTap: () {
                            if (item.isInvoice) {
                              context.goPush(Routes.docs, pathParameters: {
                                'uid': item.invoice!.ownerId,
                                'ticketId': item.invoice!.id.toString(),
                              });
                            } else {
                              context.goPush(
                                Routes.serviceOrder,
                                pathParameters: {
                                  'uid': item.jobsheet!.ownerID,
                                  'ticketId': item.jobsheet!.ticketId.toString(),
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: content,
          );
        },
      ),
    );
  }
}
