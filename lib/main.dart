import 'package:certimonial/screen/addformat.dart';
import 'package:certimonial/screen/fingerprint_auth.dart';
import 'package:certimonial/screen/registration_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
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
        routes: {'/add-file': (BuildContext context) => AddFormat()},
        title: 'Certimonial',
        debugShowCheckedModeBanner:false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: Auth_FP(),
      ),
    );
  }
}


Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//OnSuccess Here
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deeplink = dynamicLink?.link;
        if(deeplink!=null) {
          print("deeplink data " + deeplink.queryParameters.values.first);
          Get.toNamed('/add-file');
        }
        if(deeplink!=null) {
          print("deeplink data " + deeplink.queryParameters.values.first);
        }
      };
    }).onError((error) async{
//onError Here
    print(error);

    });
  }



