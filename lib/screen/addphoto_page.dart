import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'secondpage.dart';

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  User? user = FirebaseAuth.instance.currentUser;
  late Position currentLocation;
  DateTime now = DateTime.now();
  bool uploading = false;
  double val = 0;

  late CollectionReference imgRef2;
  late firebase_storage.Reference ref;

  final List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Photos'),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(
                    () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SecondPage(),
                    )),
                  );
                },
                child: Text(
                  'upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.pink,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.drive_folder_upload_rounded,
                                      color: Colors.yellow,
                                    ),
                                    onPressed: () => !uploading
                                        ? chooseImage(ImageSource.gallery)
                                        : null),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.purple,
                                child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.lightGreenAccent,
                                    onPressed: () => !uploading
                                        ? chooseImage(ImageSource.camera)
                                        : null),
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  chooseImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future<Position> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future uploadFile() async {
    int i = 1;
    currentLocation = await _getCurrentLocation();

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('${user!.uid}/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {

          imgRef2.add({
            'url': value,
            'datetime': FieldValue.serverTimestamp(),
            'description': "Click to edit description/remark",
            'location':
                "${currentLocation.latitude}, ${currentLocation.longitude}",
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
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    imgRef2 = FirebaseFirestore.instance.collection(user!.uid);
  }
}
