import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rider/screens/Drawer/drawer.dart';
import 'package:rider/screens/QR/qr_scann_functionality.dart';
import 'package:rider/utils/color.dart';
import 'dart:convert';
import 'package:rider/utils/image.dart';
class QRController extends GetxController {
  // final scannedResults = List<Map<String, dynamic>>().obs;
  final scannedResults = <Map<String, dynamic>>[].obs;
  Future<void> fetchDataFromAPI(String masterNo) async {
    try {
      var headers = {
        'Ridername': 'zainKhan',
        'Riderpassword': 'demo@1234',
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=fc5f9fd74d1006552eb94b08ea7dc0c1'
      };
      var requestBody = json.encode({"master_no": masterNo});
      var response = await http.post(Uri.parse('https://falcon.onelogitech.com/api/riderapp_loadsheet'), headers: headers, body: requestBody);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var body = jsonResponse['data']['body'];
        if (body != null && body is List) {
          scannedResults.assignAll(body.cast<Map<String, dynamic>>());
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception thrown: $e');
    }
  }
}
class QRScreen extends StatefulWidget {
  @override
  _QRScreenState createState() => _QRScreenState();
}
class _QRScreenState extends State<QRScreen> {
  final QRController qrController = Get.put(QRController());
  @override
  void initState() {
    super.initState();
    qrController.fetchDataFromAPI("1");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: RColor.accent,
        leading: IconButton(
          onPressed: () {Get.back();},
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Scan QR Code"),
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(CameraScreen());
            },
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                RImage.MainQR,
                height: 32,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(NewD());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                RImage.Menu,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5,),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: qrController.scannedResults.length,
                itemBuilder: (context, index) {
                  var data = qrController.scannedResults[index];
                  return Card(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Master No: ${data['master_no']}"),
                            Text("Shipment No: ${data['shipment_no']}"),
                            Text("Shipment Date: ${data['shipment_date']}"),
                            Text("Consignee Name: ${data['consignee_name']}"),
                            Text("Consignee Address: ${data['consignee_address']}"),
                            Text("Cash Collect: ${data['cash_collect']}"),
                            Text("Consignee Contact: ${data['consignee_contact']}"),
                            Text("Account Number: ${data['account_number']}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.pink,
                          onPressed: () {
                            qrController.scannedResults.removeAt(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refresh data when fab is pressed
          qrController.fetchDataFromAPI("1"); // You can pass the desired master number here
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}



///////////API complete code////////////