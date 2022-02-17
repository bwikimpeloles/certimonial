import 'dart:io';
import 'package:certimonial/screen/choosepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//this class is for uploading pdf file from device

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  User? user = FirebaseAuth.instance.currentUser;
  File? file;
  String url = "";
  var name;
  var color1 = Colors.redAccent[700];

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
                  color: Colors.white
                ),
              ),
              color: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }

  getfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
      ],
    );

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
      var pdffile =
      FirebaseStorage.instance.ref().child('pdf').child(user!.uid).child("/$name");
      UploadTask task = pdffile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();

      print(url);

      if (url != null && file != null) {
        Fluttertoast.showToast(
          msg: "Done Uploaded",
          textColor: Colors.red,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChoosePage()),
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
