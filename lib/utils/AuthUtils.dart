import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthUtils{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignIn gAuth = GoogleSignIn();

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await gAuth.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await auth.signInWithCredential(credential);
  }

  static bool isUserSignedin(){
    return auth.currentUser != null;
  }

  static User getUserDetails(){
    return auth.currentUser;
  }

  static Future<void> deleteUser() async {
    await gAuth.disconnect();
    await auth.currentUser?.delete();
  }
}