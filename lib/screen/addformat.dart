import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '/screen/thirdpage.dart';

//this class is for uploading any format of file from device

class AddFormat extends StatefulWidget {
  @override
  _AddFormatState createState() => _AddFormatState();
}

class _AddFormatState extends State<AddFormat> {
  User? user = FirebaseAuth.instance.currentUser;
  File? file;
  String url = "";
  var name;
  var color1 = Colors.redAccent[700];
  late CollectionReference fileRef;
  late Position currentLocation;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    fileRef = FirebaseFirestore.instance
        .collection('allformat')
        .doc(user!.uid)
        .collection(user!.uid);
  }

  Future<Position> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
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
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 5.0,
              height: 60,
              minWidth: 250,
              onPressed: () {
                getfile();
              },
              child: Text(
                "Add File",
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
              ),
              color: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }

  getfile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      File c = File(result.files.single.path.toString());
      setState(() {
        file = c;
        name = result.names.toString();
      });
      uploadFile();
    }
  }

  uploadFile() async {
    try {
      Fluttertoast.showToast(
        msg: "Please wait...",
        textColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      var allfile = FirebaseStorage.instance
          .ref()
          .child('allformat')
          .child(user!.uid)
          .child("/$name");
      UploadTask task = allfile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      currentLocation = await _getCurrentLocation();
      fileRef.add({
        'url': url,
        'datetime': FieldValue.serverTimestamp(),
        'description': "Click to edit description/remark",
        'location': "${currentLocation.latitude}, ${currentLocation.longitude}",
        'datentime': now.day.toString() +
            "-" +
            now.month.toString() +
            "-" +
            now.year.toString() +
            "   " +
            now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
      });

      print(url);

      if (url != null && file != null) {
        Fluttertoast.showToast(
          msg: "Done Uploaded",
          textColor: Colors.red,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThirdPage()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          textColor: Colors.red,
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Colors.red,
      );
    }
  }
}
