
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xerneas/main.dart';
import 'dart:async';


class NewTask extends StatefulWidget {
  NewTask();
  @override
  _NewTaskState createState() => _NewTaskState();
}

double dett = MyHomePage().createState().latLng.latitude;
double bett = MyHomePage().createState().latLng.longitude;

class _NewTaskState extends State<NewTask> {
  @override
  void initState() {
    super.initState();
  }

  String contact, board, material, remarks, address;

  getContact(c) {
    this.contact = c;
  }

  getBoard(b) {
    this.board = b;
  }

  getMaterial(m) {
    this.material = m;
  }

  getRemarks(q) {
    this.remarks = q;
  }

  getAddress(h) {
    this.address = h;
  }


  int grade = 0;
  String itemVal;

  void _handleTaskType(int v) {
    setState(() {
      grade = v;
      switch (grade) {
        case 1:
          itemVal = '9';
          break;
        case 2:
          itemVal = '10';
          break;
        case 3:
          itemVal = '11';
          break;
        case 4:
          itemVal = '12';
          break;
        default:
          itemVal = 'Other';
          break;
      }
    });
  }

  createData() {
    print(dett);
    DocumentReference dr = Firestore.instance
        .collection('marker')
        .document("" + contact + remarks);
    Map<String, dynamic> itemslist = {
      "contact_info": contact,
      "longitude": bett,
      "latitude": dett,
      "material": material,
      "board": board,
      "remarks": remarks,
      "grade": itemVal,
      "address": address,
    };
    dr.setData(itemslist).whenComplete(() {
      print("Saved");
    });
  }

  @override
  Widget build(BuildContext context) {
    _getpos();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text("Add Your Details", style: TextStyle()),
        ),
      ),
      resizeToAvoidBottomPadding: true,
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xffffe699), const Color(0xffff9900)])),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                        onChanged: (String c) {
                          getContact(c);
                        },
                        decoration: InputDecoration(
                            labelText: "Contact info and Address :",
                            prefixIcon: Icon(FontAwesomeIcons.addressCard,
                                color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                        onChanged: (String m) {
                          getMaterial(m);
                        },
                        decoration: InputDecoration(
                            labelText: "Material : ",
                            prefixIcon: Icon(FontAwesomeIcons.book,
                                color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                        onChanged: (String b) {
                          getBoard(b);
                        },
                        decoration: InputDecoration(
                            labelText: "Education Board : ",
                            prefixIcon: Icon(FontAwesomeIcons.teeth,
                                color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        onChanged: (String qty) {
                          getRemarks(qty);
                        },
                        decoration: InputDecoration(
                            labelText: "Remarks : ",
                            prefixIcon:
                            Icon(FontAwesomeIcons.th, color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "Select Grade :",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 1,
                              onChanged: _handleTaskType,
                              groupValue: grade,
                              activeColor: Colors.black,
                            ),
                            Text(
                              "9",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 2,
                              onChanged: _handleTaskType,
                              groupValue: grade,
                              activeColor: Colors.black,
                            ),
                            Text(
                              "10",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 3,
                              onChanged: _handleTaskType,
                              groupValue: grade,
                              activeColor: Colors.black,
                            ),
                            Text(
                              "11",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 4,
                              onChanged: _handleTaskType,
                              groupValue: grade,
                              activeColor: Colors.black,
                            ),
                            Text(
                              "12",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 5,
                              onChanged: _handleTaskType,
                              groupValue: grade,
                              activeColor: Colors.black,
                            ),
                            Text(
                              "Other",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            color: Color(0xffffe699),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            )),
                        RaisedButton(
                            color: Color(0xffffe699),
                            onPressed: () {
                              createData();
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          )));
  }

  Future<void> _getpos() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double a = position.latitude;
    double b = position.longitude;
    dett = a;
    bett = b;
    setState(() {
      dett = a;
      bett = b;
    });
  }
}




