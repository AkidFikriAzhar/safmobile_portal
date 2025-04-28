import 'package:flutter/material.dart';

class ChoosePaymentMethodBottomsheet extends StatefulWidget {
  const ChoosePaymentMethodBottomsheet({super.key});

  @override
  State<ChoosePaymentMethodBottomsheet> createState() => _ChoosePaymentMethodBottomsheetState();
}

class _ChoosePaymentMethodBottomsheetState extends State<ChoosePaymentMethodBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return const SizedBox();
      },
    );
  }
}
