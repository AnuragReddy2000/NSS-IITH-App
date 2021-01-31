import 'package:flutter/material.dart';
import 'package:nss_iith/pages/WebViewPage.dart';
import 'package:nss_iith/pages/QRPage.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.top/2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/bannerNSS.jpg'),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "about",
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>WebViewPage("https://nss.iith.ac.in/#about"))), 
                        label: Text("About NSS", style: TextStyle(fontSize: 16),),
                        icon: Icon(Icons.info_outline),
                        backgroundColor: Colors.blue[900],
                      ),
                      FloatingActionButton.extended(
                        heroTag: "attendance",
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> QRPage())), 
                        label: Text("Attendance", style: TextStyle(fontSize: 16),),
                        icon: Icon(Icons.how_to_reg),
                        backgroundColor: Colors.blue[900],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "team",
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>WebViewPage("https://nss.iith.ac.in/team.html"))), 
                        icon: Icon(Icons.people_outline),
                        label: Text("NSS team", style: TextStyle(fontSize: 16),),
                        backgroundColor: Colors.blue[900],
                      ),
                      FloatingActionButton.extended(
                        heroTag: "hours",
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>WebViewPage("https://nss.iith.ac.in/hours_portal/"))),
                        label: Text("Hours Portal", style: TextStyle(fontSize: 16),),
                        icon: Icon(Icons.history_toggle_off),
                        backgroundColor: Colors.blue[900],
                      ),
                    ],
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}