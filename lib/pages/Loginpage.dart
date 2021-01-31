import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:nss_iith/pages/Homepage.dart';
import 'package:nss_iith/utils/AuthUtils.dart';

class LoginPage extends StatefulWidget{

  @override 
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  bool isLoading = false;

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
                SizedBox(
                  width: 260,
                  height: 50,
                  child: SignInButton(
                    Buttons.GoogleDark,
                    text: "Sign in with Google",
                    onPressed: () async {
                      this.setState(() {
                        isLoading = true;
                      });
                      await AuthUtils.signInWithGoogle();
                      if(AuthUtils.isUserSignedin()){
                        final user = AuthUtils.getUserDetails();
                        if(user.email.contains('iith.ac.in')){
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (BuildContext context) => HomePage()), 
                            (route) => false
                          );
                        }
                        else{
                          await AuthUtils.deleteUser();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Sign In Alert"),
                              content: Text("Please sign in with the mail id provided to you by IITH ( __iith.ac.in )"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), 
                                  child: Text("Ok")
                                )
                              ],
                            ),
                            barrierDismissible: true,
                          );
                        }
                      }
                      this.setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                ),
                isLoading ? Container(
                  child: LinearProgressIndicator(), 
                  width: 260,
                  margin: EdgeInsets.only(top: 2),
                ) : Container(height: 0,)
              ],
            )
          ],
        ),
      ),
    );
  }
}