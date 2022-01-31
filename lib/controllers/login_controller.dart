import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginController with ChangeNotifier {
  // object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;

  GoogleSignInAccount get user => googleSignInAccount!;

//might delete later
// a simple sialog to be visible everytime some error occurs
  showErrDialog(BuildContext context, String err) {
    // to hide the keyboard, if it is still p
    FocusScope.of(context).requestFocus(new FocusNode());
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("Error"),
          content: Text(err),
          actions: <Widget>[
            OutlineButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  } //might delete later

  // fucntion for google login
  googleLogin() async {
    this.googleSignInAccount = await _googleSignIn.signIn();
    // inserting values to our user details model

    this.userDetails = new UserDetails(
      displayName: this.googleSignInAccount!.displayName,
      email: this.googleSignInAccount!.email,
      photoURL: this.googleSignInAccount!.photoUrl,
    );

    if (googleSignInAccount == null) return;
    googleSignInAccount = googleSignInAccount;
    final googleAuth = await googleSignInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    // call
    notifyListeners();
  }

  // function for facebook login
  facebooklogin() async {
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );
// Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    // check the status of our login
    if (result.status == LoginStatus.success) {
      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );

      this.userDetails = new UserDetails(
        displayName: requestData["name"],
        email: requestData["email"],
        photoURL: requestData["picture"]["data"]["url"] ?? " ",
      );

      notifyListeners();
    }
  }

  // logout

  logout() async {
    this.googleSignInAccount = await _googleSignIn.signOut();
    await FacebookAuth.i.logOut();
    userDetails = null;
    notifyListeners();
  }
}
