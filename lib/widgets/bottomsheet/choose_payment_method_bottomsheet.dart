import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safmobile_portal/provider/payment_provider.dart';

class ChoosePaymentMethodBottomsheet extends StatefulWidget {
  const ChoosePaymentMethodBottomsheet({super.key});

  @override
  State<ChoosePaymentMethodBottomsheet> createState() => _ChoosePaymentMethodBottomsheetState();
}

class _ChoosePaymentMethodBottomsheetState extends State<ChoosePaymentMethodBottomsheet> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      animationController: BottomSheet.createAnimationController(this),
      showDragHandle: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return Consumer<PaymentProvider>(builder: (context, paymentProvider, child) {
          return ListView(
            shrinkWrap: true,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 1,
                title: Text('Bank Transfer via FPX'),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 3,
                title: Text('Debit Card'),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 4,
                title: Text('Credit Card'),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 5,
                title: Text('eWallet'),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 8,
                title: Text('Boost PayFlex'),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                child: SizedBox(
                  height: 55,
                  child: FilledButton(
                    onPressed: () {
                      print(paymentProvider.currentPaymentMethod);
                      context.pop(
                        paymentProvider.currentPaymentMethod,
                      );
                    },
                    child: Text('Pay Now'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        });
      },
    );
  }
}
