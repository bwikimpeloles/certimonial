import 'package:certimonial/controllers/login_controller.dart';
import 'package:certimonial/screen/secondpage.dart';
import 'package:certimonial/screen/thirdpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await Provider.of<LoginController>(context, listen: false)
                    .logout();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Image.asset("assets/logo.png", fit: BoxFit.contain),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              elevation: 5.0,
              height: 60,
              minWidth: 250,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
              child: Text(
                "Image",
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
              ),
              color: Colors.deepOrange,
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              elevation: 5.0,
              height: 60,
              minWidth: 250,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ThirdPage()));
              },
              child: Text(
                "Document",
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
              ),
              color: Colors.deepOrange,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
