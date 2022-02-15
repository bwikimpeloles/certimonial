import 'package:certimonial/screen/firstpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/model/database3.dart';

class View3 extends StatefulWidget {
  View3({Key? key, required this.detail, required this.db}) : super(key: key);
  Map detail;
  Database3 db;
  @override
  _View3State createState() => _View3State();
}

class _View3State extends State<View3> {
  TextEditingController descController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController datentimeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.detail);
    descController.text = widget.detail['description'];
    locationController.text = widget.detail['location'];
    datentimeController.text = widget.detail['datentime'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Description View"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: inputDecoration("Description/Remark"),
                controller: descController,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration("Location (Lat, Long) or Address"),
                controller: locationController,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration("Date and Time"),
                controller: datentimeController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          child: RaisedButton(
              color: Colors.black,
              onPressed: () {
                widget.db.update(widget.detail['id'], descController.text,
                    locationController.text, datentimeController.text);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FirstPage(),
                ));
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      focusColor: Colors.lightBlue,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.lightBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2.0,
        ),
      ),
    );
  }
}
