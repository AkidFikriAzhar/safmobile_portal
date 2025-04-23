import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ToyyibpayApi {
  Future<void> createToyyibPayCategory(String categoryName, String categoryDescription) async {
    final uri = Uri.parse('https://dev.toyyibpay.com/index.php/api/createCategory');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'catname': categoryName,
        'catdescription': categoryDescription,
        'userSecretKey': 'heb9a24z-3o0i-925j-2mug-52y1v8uehmw6',
      },
    );
    if (response.statusCode == 200) {
      log('Respon dari server: ${response.body}');

      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List && decoded.isNotEmpty && decoded[0]['CategoryCode'] != null) {
          final categoryCode = decoded[0]['CategoryCode'];
          log('Kategori berjaya dicipta. Code: $categoryCode');
        } else {
          log('Kategori gagal dicipta. Respons tak seperti dijangka.');
        }
      } catch (e) {
        log('Gagal parse respons: $e');
      }
    } else {
      log('Gagal cipta kategori. Status code: ${response.statusCode}');
      log('Error: ${response.body}');
    }
  }
}
