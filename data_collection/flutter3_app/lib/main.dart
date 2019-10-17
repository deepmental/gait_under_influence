import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors/sensors.dart';
import 'dart:io';
import 'dart:async' show future;
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;



void main() => runApp(DataCollection());



class DataCollection extends StatelessWidget {
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

                    DateTime datetime = DateTime.now();

                    int count = 0;
                    List IMU  = [];
                    List gyro = [];

                    Stopwatch timer = Stopwatch()..start();


                    gyroscopeEvents.listen((GyroscopeEvent event){
                      gyro.add([event.x, event.y, event.z]);

                    });

                    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
                      firestore(titleControler.text, bodyControler.text, event.x, event.y, event.z, gyro[0][0], gyro[0][1], gyro[0][2], time, datetime.toString());
                      if (timer.elapsedMilliseconds/1000 >= (4*3600)){
                        exit(0);


                      }

                    }

                    );

                    },
                  child: const Text("Send"),
                )
              ],
            ),
          )),

    );
  }
}


firestore(String name, String intoxication, double x, double y, double z, double x1, double y1, double z1, int timestamp, String datetime) {
// Delete the database
// open the database
  DocumentReference document = Firestore.instance.collection('data').document();
  document.setData({
    'name': name,
    'intoxication': intoxication,
    'x': x,
    'y': y,
    'z': z,
    'x1': x1,
    'y1': y1,
    'z1': z1,
    'timestamp': timestamp,
    'datetime': datetime
  });
}


