import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors/sensors.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';



class MyApp extends StatelessWidget {
  TextEditingController titleControler = new TextEditingController();
  TextEditingController bodyControler = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List type_data_time = [];

    return MaterialApp(
      title: "WEB SERVICE",
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('AlcoGait'),
          ),
          body: new Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: titleControler,
                  decoration: InputDecoration(
                      hintText: "title....", labelText: 'Name'),

                ),
                new TextField(
                  controller: bodyControler,
                  decoration: InputDecoration(
                      hintText: "title....", labelText: 'Drunk or not'),

                ),

                new RaisedButton(
                  onPressed: () async {

                    int time = DateTime.now().millisecondsSinceEpoch;
                    List IMU_gravitynull = [];
                    int count = 0;

                    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
                      DateTime timestamp = DateTime.now();
                      IMU_gravitynull.add(event);
                      firestore(titleControler.text, bodyControler.text, event.x, event.y, event.z, timestamp.toString());

                    });

                    },
                  child: const Text("Create"),
                )
              ],
            ),
          )),
    );
  }
}


firestore(String name, String intoxication, double x, double y, double z, String timestamp) async{
// Delete the database
// open the database
  DocumentReference document = Firestore.instance.collection('data').document();
  document.setData({ 'name': name, 'intoxication': intoxication, 'x': x, 'y': y, 'z': z, 'timestamp': timestamp});


}

void main() => runApp(MyApp());
