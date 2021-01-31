import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nss_iith/utils/AuthUtils.dart';
import 'package:nss_iith/utils/NetworkUtils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRPage extends StatefulWidget{

  @override 
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage>{
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Widget resultMsg;
  bool showMsg = false;
  bool showLoader = false;
  QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> onQRScanFail(String errorText) async {
    this.setState(() {
      showLoader = false;
      showMsg = true;
      resultMsg = Text(
        errorText, 
        style: TextStyle(color: Colors.red[900], fontSize: 16, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      );
    });
    await controller.resumeCamera();
  }

  Future<void> onQRScan(Barcode result, BuildContext context) async {
    this.setState(() {
      showLoader = true;
      showMsg = false;
    });
    if(await NetworkUtils.isDeviceConnected(5)){
      try {
        final payload = JsonDecoder().convert(result.code);
        if(payload is Map && payload.containsKey("event") && 
          payload.containsKey("type") && payload.containsKey("url")){
            List<dynamic> pastEvents = await NetworkUtils.getCompletedEvents();
            if(pastEvents!=null && pastEvents.map((e) => e["event_name"]).contains(payload["event"].toString())){
              onQRScanFail("Cannot give attendance for the same QR twice...");
            }
            else{
              final status = await markAttendance(payload);
              if(status){
                this.setState(() {
                  showLoader = false;
                  showMsg = true;
                  resultMsg = Text(
                    "Attendance given successfully for "+ payload["event"].toString() +"! Thank you.", 
                    style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  );
                });
                if(pastEvents == null){
                  pastEvents = [];
                }
                pastEvents.add({
                  "event_name": payload["event"],
                  "timestamp" : DateTime.now().toLocal().toString()
                });
                NetworkUtils.saveEvents(pastEvents);
                await Future.delayed(Duration(milliseconds: 1500)); 
                Navigator.pop(context);
              }
              else{
                onQRScanFail("Oops... Something went wrong. Try again or contact the NSS Team");
              }
            }
        }
        else{
          await onQRScanFail("Oops... invalid QR code. Try again or contact the NSS Team");
        }
      } on FormatException catch (e) {
        await onQRScanFail("Oops... invalid QR code. Try again or contact the NSS Team");
      }   
    }
    else{
      onQRScanFail("Device not connected to internet!");
    } 
  }

  Future<bool> markAttendance(Map<String,dynamic> payload) async {
    final url = payload["url"].toString();
    final nameField = payload["name"].toString();
    final emailField = payload["email"].toString();    
    final user = AuthUtils.getUserDetails();
    Map body = {
      nameField: user.displayName,
      emailField: user.email
    };
    if(payload["type"] != "default"){
      final bagsField = payload["bags"].toString();
      body.addAll({bagsField: 0.toString()});
    }
    return await NetworkUtils.post(url, body);
  }

  @override 
  Widget build(BuildContext content){
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.top/2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width*0.9,
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/bannerSmall.jpg'),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Please scan the QR code", style: TextStyle(color: Colors.black87, fontSize: 21),),
                Container(
                  margin: EdgeInsets.only(top:20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[900], width: 10),
                    borderRadius: BorderRadius.circular(10) 
                  ),
                  height: MediaQuery.of(context).size.width*0.8,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: QRView(
                    key: qrKey, 
                    onQRViewCreated: (QRViewController controller) async {
                      this.controller = controller;
                      controller.scannedDataStream.listen((scanData) async {
                        await controller.pauseCamera();
                        await onQRScan(scanData, context);
                      });
                    }
                  ),
                ),
                showMsg ? Container(
                  margin: EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width*0.8,
                  child: resultMsg,
                ) : Container(height: 0),
                showLoader ? Container(
                  margin: EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width*0.8,
                  child: LinearProgressIndicator(),
                ) : Container(height: 0)
              ],
            )
          ],
        ),
      ),
    );
  }
}