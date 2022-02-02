import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/controllers/login_controller.dart';
import '/screen/login_screen.dart';
import 'addpage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _FirstPageState extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                Icons.folder,
              ),
              iconSize: 65.0,
              color: Colors.deepOrange,
              splashColor: Colors.orange,
              onPressed: () {},
            ),
            color: Colors.orange[200],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPage()),
            );
          }),
    );
  }
}
