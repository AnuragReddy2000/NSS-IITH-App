import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nss_iith/pages/Loginpage.dart';
import 'package:nss_iith/utils/AuthUtils.dart';
import 'pages/Homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<bool> initialize() async {
    await Firebase.initializeApp();
    return AuthUtils.isUserSignedin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: initialize(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if(!snapshot.data){
            return LoginPage();
          }
          return HomePage();
        }
      )
    );
  }
}

