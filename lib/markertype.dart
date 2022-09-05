
import 'package:flutter/material.dart';


class MarkerType extends StatefulWidget {
  MarkerType();
  @override
  _MarkerState createState() => _MarkerState();
}


class _MarkerState extends State<MarkerType>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text("Marker Types", style: TextStyle()),
        ),
      ),
      body: Image.asset('images/infopage.png')

    );

  }

}