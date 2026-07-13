import 'dart:convert';
import 'package:http/http.dart' as http;

class BayarcashApi {
  static const paymentIntentUrlProduction =
      'https://console.bayar.cash/payment-intent/';

  Future<String> createBayarCashPaymentIntentFromFunctions({
    required String name,
    required String email,
    required String phoneNumber,
    required double amount,
    required String ticketId,
    required int paymentMethod,
  }) async {
    final url = Uri.parse(
      'https://us-central1-safmobile-database.cloudfunctions.net/createBayarCashPaymentIntent',
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "amount": amount,
        "ticketId": ticketId,
        "paymentMethod": paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id']; // ID payment intent dari BayarCash
    } else {
      throw Exception('Gagal cipta BayarCash: ${response.body}');
    }
  }
}
