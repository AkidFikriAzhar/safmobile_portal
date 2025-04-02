import 'package:flutter/material.dart';
import 'package:safmobile_portal/extensions/route_extension.dart';
import 'package:safmobile_portal/routes.dart';

class HomeController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  void search(BuildContext context) {
    context.goPush(Routes.search, queryParameters: {
      'ticketId': searchController.text.trim(),
    });
  }
}
