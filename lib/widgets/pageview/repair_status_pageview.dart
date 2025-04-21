import 'package:flutter/material.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';
import 'package:safmobile_portal/model/jobsheet.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timelines_plus/timelines_plus.dart';

class RepairStatusPageview extends StatefulWidget {
  final Jobsheet jobsheet;
  const RepairStatusPageview({super.key, required this.jobsheet});

  @override
  State<RepairStatusPageview> createState() => _RepairStatusPageviewState();
}

class _RepairStatusPageviewState extends State<RepairStatusPageview> {
  List<IconData> iconsSuccess = [
    Icons.watch_later_outlined,
    Icons.search_outlined,
    Icons.construction_outlined,
    Icons.checklist_rtl_rounded,
    Icons.verified_outlined,
    Icons.check_circle_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final jobsheet = widget.jobsheet;
    List<String> title = [
      context.localization.pending,
      context.localization.diagnose,
      context.localization.repair,
      context.localization.checking,
      context.localization.done,
      'yahah',
    ];

    List<String> subtitle = [
      context.localization.pendingDescription,
      context.localization.diagnoseDescription,
      context.localization.repairDescription,
      context.localization.checkingDescription,
      context.localization.doneDescription,
      'yahaha',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Timeline.tileBuilder(
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemCount: jobsheet.progressStep + 1 < 5 ? jobsheet.progressStep + 2 : 5,
          contentsAlign: ContentsAlign.alternating,
          indicatorBuilder: (_, index) {
            bool incomplete = index >= jobsheet.progressStep + 1;
            bool isError = jobsheet.returnPosition != null;
            return DotIndicator(
              size: 40,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Center(
                child: incomplete == true
                    ? isError == false
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.surfaceTint,
                              ),
                            ),
                          )
                        : Icon(Icons.warning)
                    : Icon(iconsSuccess[index]),
              ),
            );
          },
          connectorBuilder: (_, index, __) {
            // Tunjuk line antara step, kecuali sebelum first dan selepas last
            if (index == 0) {
              return const SizedBox.shrink(); // No line before first
            }
            return DashedLineConnector(
              color: Theme.of(context).colorScheme.outline,
              thickness: 2,
              gap: 5,
            );
          },
          contentsBuilder: (context, index) {
            bool isSkeleton = jobsheet.progressStep + 1 <= index;
            bool isError = jobsheet.returnPosition != null;

            return Skeletonizer(
              enabled: isSkeleton == true && isError == true ? false : isSkeleton,
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isError == true && jobsheet.returnPosition == index - 1 ? context.localization.returnReason : title[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isError == true && jobsheet.returnPosition == index - 1 ? '${context.localization.reason}: ${jobsheet.returnReason}' : subtitle[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
