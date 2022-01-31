import 'screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'controllers/login_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF151026);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(),
          child: LoginScreen(),
        )
      ],
      child: MaterialApp(
        title: 'Certimonial',
        debugShowCheckedModeBanner:false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
