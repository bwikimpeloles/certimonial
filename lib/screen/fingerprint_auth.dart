import 'package:certimonial/screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:local_auth/local_auth.dart';

class Auth_FP extends StatelessWidget {
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

          if (weCanCheckBiometrics) {
            bool authenticated = await localAuth.authenticate(
              localizedReason: "Authenticate to access Certimonial.",
            );

            if (authenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            }
          }
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              Text(
                "Touch to Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.deepOrangeAccent),
                textAlign: TextAlign.center,
              ),
            ]),
      ),
    );
  }
}
