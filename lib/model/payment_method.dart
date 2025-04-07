import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

enum PaymentMethod {
  cash,
  qrPay,
  transfer,
  tng,
  fpx,
  creditCard,
  debitCard,
  payLater,
  expense,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.qrPay:
        return 'QR Pay';
      case PaymentMethod.transfer:
        return 'Bank Transfer';
      case PaymentMethod.tng:
        return 'Touch \'n Go';
      case PaymentMethod.fpx:
        return 'Fpx Transactions';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.payLater:
        return 'Pay Later';
      case PaymentMethod.expense:
        return 'Expense';
    }
  }

  IconData get icons {
    switch (this) {
      case PaymentMethod.cash:
        return MdiIcons.cash;
      case PaymentMethod.qrPay:
        return Icons.qr_code_2;
      case PaymentMethod.transfer:
        return MdiIcons.bankTransfer;
      case PaymentMethod.tng:
        return MdiIcons.contactlessPaymentCircle;
      case PaymentMethod.fpx:
        return MdiIcons.appsBox;
      case PaymentMethod.creditCard:
        return MdiIcons.creditCard;
      case PaymentMethod.debitCard:
        return MdiIcons.creditCardChipOutline;
      case PaymentMethod.payLater:
        return MdiIcons.cashSync;
      case PaymentMethod.expense:
        return MdiIcons.cashMinus;
    }
  }
}

class PaymentMethodHelper {
  static Future<PaymentMethod> selectPaymentMethod() async {
    PaymentMethod payment = PaymentMethod.cash;

    return payment;
  }
}
