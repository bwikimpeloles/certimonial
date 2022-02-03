import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class DisplayFull extends StatefulWidget {
  String url = "";

  DisplayFull({Key? key, required this.url}) : super(key: key);

  @override
  _DisplayFullState createState() => _DisplayFullState();
}

class _DisplayFullState extends State<DisplayFull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.share, color: Colors.white),
            )
          ],
        ),
        body: Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
              child: FadeInImage.memoryNetwork(
            fit: BoxFit.cover,
            placeholder: kTransparentImage,
            image: widget.url,
          )),
        ])));
  }
}
