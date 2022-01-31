import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/controllers/login_controller.dart';
import '/screen/login_screen.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _FirstPageState extends State<FirstPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Page'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await Provider.of<LoginController>(context, listen: false)
                    .logout();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0), child: Text('Firstpage')),
    );
  }
}
