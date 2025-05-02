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
                title: Row(
                  children: [
                    Text('Bank Transfer via FPX'),
                    const Spacer(),
                    Image.asset(
                      Theme.of(context).brightness == Brightness.light ? 'assets/images/fpx_light.png' : 'assets/images/fpx_dark.png',
                      width: 45,
                      height: 45,
                    ),
                  ],
                ),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 3,
                title: Row(
                  children: [
                    Text('Debit Card'),
                    const Spacer(),
                    Row(
                      spacing: 5,
                      children: [
                        Image.asset(
                          'assets/images/visa.png',
                          width: 45,
                          height: 45,
                        ),
                        Image.asset(
                          'assets/images/mastercard.png',
                          width: 45,
                          height: 45,
                        ),
                      ],
                    ),
                  ],
                ),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 4,
                title: Row(
                  children: [
                    Text('Credit Card'),
                    const Spacer(),
                    Row(
                      spacing: 5,
                      children: [
                        Image.asset(
                          'assets/images/visa.png',
                          width: 45,
                          height: 45,
                        ),
                        Image.asset(
                          'assets/images/mastercard.png',
                          width: 45,
                          height: 45,
                        ),
                      ],
                    ),
                  ],
                ),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 5,
                title: Row(
                  children: [
                    Text('eWallet'),
                    const Spacer(),
                    Row(
                      spacing: 5,
                      children: [
                        Image.asset(
                          'assets/images/boost.png',
                          width: 35,
                          height: 35,
                        ),
                        Image.asset(
                          'assets/images/tng.png',
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  ],
                ),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              RadioListTile<int>(
                visualDensity: VisualDensity(vertical: 3),
                value: 8,
                title: Row(
                  children: [
                    Text('Boost PayFlex'),
                    const Spacer(),
                    Row(
                      spacing: 5,
                      children: [
                        Image.asset(
                          'assets/images/boost.png',
                          width: 35,
                          height: 35,
                        ),
                        Text(
                          'PayFlex',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
                groupValue: paymentProvider.currentPaymentMethod,
                onChanged: (value) => paymentProvider.setCurrentPaymentMethod(value!.toInt()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                child: SizedBox(
                  height: 55,
                  child: FilledButton(
                    onPressed: () {
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
