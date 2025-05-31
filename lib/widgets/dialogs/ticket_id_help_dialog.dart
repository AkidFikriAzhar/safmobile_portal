import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/extensions/locale_extension.dart';

class TicketIdHelpDialog extends StatelessWidget {
  const TicketIdHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.help_outline),
      title: Text(context.localization.whatIsTicketId),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/ticket_id_help.png',
              height: 250,
            ),
            SizedBox(
              width: 450,
              child: Text(context.localization.whatIsTicketIdDesc),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
