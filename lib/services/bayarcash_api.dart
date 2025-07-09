import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:safmobile_portal/model/fpx_bank.dart';

class BayarcashApi {
  static const secretKeySandbox =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiZDM4MjI5ZTQ5NTllYzQ4Mjg5NDU1Yzg1ZmYyMzMwMTQxNTVlYzI4ZjA0MDIyZjc4YzVhOWFkNWZlZDIxZDBjNzYwYmIwYWI2MGY5YjM5ZDMiLCJpYXQiOjE3MjQxNDAwNDEuMDgwNTM1LCJuYmYiOjE3MjQxNDAwNDEuMDgwNTM3LCJleHAiOjIwMzk2NzI4NDEuMDc5OTAxLCJzdWIiOiI2Iiwic2NvcGVzIjpbIioiXX0.Kn6MXwi6d33aZQpnQqq_Ng7b6UeNlZiXIJ-Jth6PmUoRJBTmw4hdAlDQVSJRosHN4giUBm1lquflNnjqpwI9-bBv-ttqF79X3GjW2GMkYzAnvghGyEn5ldQwBQdmp8pjm7o4Pn1faMe81I5rehQLM8rJFnnQsArKzHl6ZHi7w4gMscIsP-ISWnTN7zO0nBNw6KA5ZpGhhPPhM8Zfrq4nmDWtne6-8h1VoFErPTaKu_GfDXma3PnfJaGwGtWJdJePB6wpR_FwrsB8zgByyOilgRTNZiTBHio4-c-T0V1UU48SDojmCEYNuD1iSdQC-MRaAKUaHdWy7kfmyOy7FohmBbqsag8F47UjDD97VoVOmfUYP6FeKGTMOBuqcOcgN42KXs0Pa6juWIHXtOqn6_WFU9oAhuELIRDX8qR_0-CEIQSJxeeKj8AWBcAvgM2iUeD15QTHJAC41EKpLpL31HboNvk4bJfol4vo3j1SBdHMLmZzI3iENBJtGEO-jNgovhzDkPkCu39u0PrA6-La7VqZ3a-6ItvRyVHcR4ud_zl2oHBl-ZggPB92XVV7yNGUOgHpbshptWbcSWR6XeHHkbNU2K9T8y9c62r-R9KzK07fvn0C3bgR7f8wwgBrZn7WR_dC6Rk_pjumCi8UvItFOgDa5TQXgUnZVBFMPZY3h8APQA0';

  static const portalKeySandbox = '779cd699e9e59a84c4581a68fd7e0130';
  static const paymentIntentUrlSandbox = 'https://console.bayarcash-sandbox.com/payment-intent/';

  Future<List<FpxBank>> getFpxBanks() async {
    const url = 'https://api.console.bayarcash-sandbox.com/v3/banks';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $secretKeySandbox',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((bank) => FpxBank.fromJson(bank)).toList();
    } else {
      throw Exception('Failed to load bank list: ${response.statusCode} ${response.body}');
    }
  }

  Future<String> createBayarCashPaymentIntent({
    required String name,
    required String email,
    required String phoneNumber,
    required double amount,
    required String ticketId,
    required int paymentMethod,
  }) async {
    // final corsProxy = 'https://proxy.corsfix.com/?';
    // final x2u = 'https://go.x2u.in/proxy?email=akidfikriazhar@gmail.com&apiKey=8967b944&url=https://www.bbc.com';
    // final x2uv2 = 'https://go.x2u.in/proxy?email=akidfikriazhar@gmail.com&apiKey=8967b944&url=';
    final apiUrl = Uri.parse('https://api.console.bayarcash-sandbox.com/v3/payment-intents');
    final sandboxPortal = '779cd699e9e59a84c4581a68fd7e0130';

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $secretKeySandbox',
      },
      body: jsonEncode({
        "payment_channel": paymentMethod,
        "portal_key": sandboxPortal,
        "order_number": ticketId,
        "amount": amount, // dalam sen
        "payer_name": name,
        "payer_email": email,
        "payer_telephone_number": phoneNumber,
        "return_url": "https://safmobile.my/payment-completed",
      }),
    );

    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      log('$paymentIntentUrlSandbox${json['id']}');
      return '${json['id']}'; // Pulangkan hanya ID
    } else {
      throw Exception('Gagal cipta bayaran: ${response.body}');
    }
  }
}
