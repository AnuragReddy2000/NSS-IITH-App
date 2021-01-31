import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:nss_iith/utils/AuthUtils.dart';

class NetworkUtils{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<bool> post(String url, dynamic body) async {
    final response = await http.post(url,body: body);
    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getCompletedEvents() async {
    final user = AuthUtils.getUserDetails();
    final result = await firestore.collection("user_records").doc(user.uid).get();
    return (result.data() == null) ? [] : result.data()["events"];
  }

  static Future<void> saveEvents(List<Map> events) async {
    final user = AuthUtils.getUserDetails();
    await firestore.collection("user_records").doc(user.uid).set({"events" : events});
  }

  static Future<bool> isDeviceConnected(int timeout) async {
    try{
      final result = await InternetAddress.lookup("bing.com").timeout(Duration(seconds: timeout));
      if (result != null && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch(_){
      return false;
    }
    return false;
  }
}