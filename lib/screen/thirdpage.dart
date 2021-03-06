import 'dart:convert';
import 'dart:io';

import 'package:certimonial/controllers/login_controller.dart';
import 'package:certimonial/model/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'addformat.dart';
import 'package:provider/provider.dart';
import '/api/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:certimonial/model/database2.dart';
import 'choosepage.dart';
import 'login_screen.dart';
import 'view2.dart';
import 'package:share_plus/share_plus.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  User? user = FirebaseAuth.instance.currentUser;
  late Future<List<FirebaseFile>> futureFiles;
  late Database2 db;
  List docs = [];

  bool _checkConfiguration() => true;

  @override
  void initState() {
    super.initState();
    _getLocationPermission();

    futureFiles = FirebaseApi.listAll('allformat/${user!.uid}/');
  }

  void _getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }

  initialise(String url) async {
    db = Database2();
    await db.initiliase();
    await db.read2(url).then((value) => {
          setState(() {
            docs = value;
          })
        });
    print(url);
  }

  launchURL(String url) async {
    await launch(url);
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;
    print('Path: ${file.path}');
    OpenFile.open(file.path);
  }

  Future shareFile({required String url, String? fileName}) async {
    final box = context.findRenderObject() as RenderBox?;

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/$fileName';

    File(path).writeAsBytesSync(bytes);

    await Share.shareFiles([path],
        text:
            '$fileName.\nDownload your file and click this link to add your file in Certimonial: https://certimonial.page.link/add-file',
        subject: 'Certimonial File Share',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0),
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  String removeFirstLastCharacter(String str) {
    String result = str;
    if ((str != null) &&
        (str.length > 0) &&
        str.startsWith('[') &&
        str.endsWith(']')) {
      String temp = str.substring(1);
      result = temp.substring(0, temp.length - 1);
    } else {
      result = str;
    }
    print(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Return to previous page',
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ChoosePage()));
          },
        ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddFormat()));
        },
      ),
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data!;

                return Container(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No duplicated file name allowed. \nTap to open file. Double tap to add remark.\nFile will not open if no appropriate document reader installed.',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange[100],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];

                                return buildFile(context, file);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) {
    var yourLink = file.url;
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Do you want to delete this file?"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                              FlatButton(
                                  onPressed: () async {
                                    await firebase_storage
                                        .FirebaseStorage.instance
                                        .refFromURL(file.url)
                                        .delete();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ThirdPage(),
                                    ));
                                  },
                                  child: Text("Yes"))
                            ],
                          );
                        });
                  }),
              IconButton(
                  onPressed: () {
                    shareFile(
                        url: file.url,
                        fileName: removeFirstLastCharacter(file.name));
                  },
                  icon: Icon(Icons.share))
            ],
          ),
          dense: false,
          leading: Icon(Icons.file_present),
          title: Text(file.name),
          //subtitle: Text(file['Location']),
        ),
      ),
      //add function later
      onTap: () {
        openFile(url: file.url, fileName: removeFirstLastCharacter(file.name));
      },
      onDoubleTap: () async {
        await initialise(file.url);

        await Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return Scaffold(
                    body: GestureDetector(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Hero(
                          tag: 'imageHero',
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                              ),
                              Text(
                                'Tap to minimize.',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 40),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 20, 10, 40),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => View2(
                                                        detail: docs[index],
                                                        db: db,
                                                        key: null,
                                                      ))).then((value) => {
                                                if (value != null)
                                                  {initialise(file.url)}
                                              });
                                        },
                                        contentPadding: EdgeInsets.only(
                                            right: 30, left: 36),
                                        title: Text(docs[index]['description']),
                                        subtitle: Wrap(
                                          spacing: 12,
                                          children: <Widget>[
                                            Text("Location: " +
                                                docs[index]['location']),
                                            Text("\n"),
                                            Text("Date/Time: " +
                                                docs[index]['datentime']),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                }));
      },
    );
  }
}
