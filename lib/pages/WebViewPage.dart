import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nss_iith/utils/NetworkUtils.dart';

class WebViewPage extends StatefulWidget{
  final String url;
  WebViewPage(this.url);

  @override 
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage>{
  InAppWebViewController webView;

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue[900],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        mini: true,
        child: Icon(Icons.home),
        onPressed: () => Navigator.pop(context),
      ),
      body: Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  if(webView != null && await webView.canGoBack()){
                    webView.goBack();
                    return false;
                  }
                  return true;
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top:MediaQuery.of(context).padding.top, 
                  ),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xff1e1e1e),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: InAppWebView(
                    initialUrl: widget.url,
                    onReceivedServerTrustAuthRequest: (InAppWebViewController controller, ServerTrustChallenge challenge) async {
                      return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                    },
                    onReceivedClientCertRequest: (InAppWebViewController controller, ClientCertChallenge challenge) async {
                      return ClientCertResponse(action: ClientCertResponseAction.PROCEED);
                    },
                    onWebViewCreated: (InAppWebViewController controller){
                      webView = controller;
                    },
                  )
                ),
              ),
              FutureBuilder(
                future: NetworkUtils.isDeviceConnected(5),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff1e1e1e), width: 7),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(
                        top:MediaQuery.of(context).padding.top, 
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  if(!snapshot.data){
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff1e1e1e), width: 7),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(
                        top:MediaQuery.of(context).padding.top, 
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text("Device not connected to the internet!", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,)
                      ),
                    );
                  }
                  return IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff1e1e1e), width: 7),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent
                      ),
                      margin: EdgeInsets.only(
                        top:MediaQuery.of(context).padding.top, 
                      ),
                      height: MediaQuery.of(context).size.height,
                    ),
                  );
                }
              )
            ],
          )
    );
  }
}