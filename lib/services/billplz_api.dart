import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class BillPlizApi {
  static const sandboxBaseUrl = 'https://www.billplz-sandbox.com/bills/';
  static const _sandboxBillApiUrl = 'https://www.billplz-sandbox.com/api/v3/bills';
  static const _sandboxApiKey = 'bd261a8b-8109-4937-9639-5ced435ced20'; //save it in .env file
  static const _sandboxCollectionId = '1ds1p46e';
  static const _callbackUrl = 'https://billplzcallback-77vl7rkrqq-uc.a.run.app';
  static const proxyServer = 'https://cors-anywhere.herokuapp.com/';

  static int _toSen(double ringgit) {
    return (ringgit * 100).round();
  }

  static Future<String?> createInvoice({
    required String name,
    required String email,
    required double amount, // Contoh: RM15.00 = 1500
    required String mobile,
    required String ticketId,
    required String userId,
  }) async {
    final url = Uri.parse('$proxyServer$_sandboxBillApiUrl');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_sandboxApiKey:'))}',
      },
      body: {
        'collection_id': _sandboxCollectionId,
        'email': email,
        'name': name,
        'mobile': mobile,
        'amount': _toSen(amount).toString(),
        'callback_url': _callbackUrl,
        'redirect_url': 'https://portal.safmobile.my/#/docs/$userId/$ticketId/',
        'description': 'Invoices#$ticketId - Computers and Smartphones Repair Service',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      log('Berjaya cipta invois: ${response.body}');
      return data['id']; // Link invois
    } else {
      log(response.statusCode.toString());
      throw ('Gagal cipta invois: ${response.body}');
      // return null;
    }
  }
}
