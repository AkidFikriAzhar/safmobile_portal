class FpxBank {
  final String bankDisplayName;
  final String bankName;
  final String bankCode;
  final String bankCodeHashed;
  final bool bankAvailability;

  FpxBank({
    required this.bankDisplayName,
    required this.bankName,
    required this.bankCode,
    required this.bankCodeHashed,
    required this.bankAvailability,
  });

  factory FpxBank.fromJson(Map<String, dynamic> json) {
    return FpxBank(
      bankDisplayName: json['bank_display_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      bankCodeHashed: json['bank_code_hashed'] ?? '',
      bankAvailability: json['bank_availability'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_display_name': bankDisplayName,
      'bank_name': bankName,
      'bank_code': bankCode,
      'bank_code_hashed': bankCodeHashed,
      'bank_availability': bankAvailability,
    };
  }
}
