import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rider/screens/QR/model/model.dart';
class LoadsheetController {
  final String apiUrl = 'https://falcon.onelogitech.com/api/riderapp_loadsheet';
  final String riderName = 'zainKhan';
  final String riderPassword = 'demo@1234';
  Future<LoadsheetModal?> fetchData(String masterNo) async {
    var headers = {
      'Ridername': riderName,
      'Riderpassword': riderPassword,
      'Content-Type': 'application/json',
      'Cookie': 'PHPSESSID=fc5f9fd74d1006552eb94b08ea7dc0c1'
    };
    var requestBody = json.encode({"master_no": masterNo});
    try {
      var response = await http.post(Uri.parse(apiUrl), headers: headers, body: requestBody);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return LoadsheetModal.fromJson(jsonResponse);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception thrown: $e');
      return null;
    }
  }
}
