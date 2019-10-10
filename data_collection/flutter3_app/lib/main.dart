import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors/sensors.dart';
import 'dart:io';
import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';



void main() => runApp(MainClass());

class MainClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new TermsPrivacy(),
      routes: <String, WidgetBuilder>{
        '/datacollection': (BuildContext context) => new DataCollection(),
      },
    );
  }
}




class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
}




class TermsPrivacy extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text overflow',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Terms of conditions and privacy policy agreement"),
        ),
        body: Column(
            children: <Widget> [

        Row(
        children: <Widget>[
        Expanded( // Constrains AutoSizeText to the width of the Row
        child: AutoSizeText(
        agreement,
          maxLines: 100,
        )
      ),
      ],
    ),
              new RaisedButton(
                  child: const Text('Agree'),
                  onPressed: () => Navigator.of(context).pushNamed('/datacollection')
              )
            ],
        ),
      ),
    );
  }
}


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
                    int count = 0;
                    List IMU  = [];
                      List gyro = [];

                      Stopwatch timer = Stopwatch()..start();


                    gyroscopeEvents.listen((GyroscopeEvent event){
                      gyro.add([event.x, event.y, event.z]);


                    });

                    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
                      firestore(titleControler.text, bodyControler.text, event.x, event.y, event.z, gyro[0][0], gyro[0][1], gyro[0][2], time);
                      if (timer.elapsedMilliseconds/1000 >= 4*3600){
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


firestore(String name, String intoxication, double x, double y, double z, double x1, double y1, double z1, int timestamp) {
// Delete the database
// open the database
  DocumentReference document = Firestore.instance.collection('data').document();
  document.setData({ 'name': name, 'intoxication': intoxication, 'x': x, 'y': y, 'z': z, 'x1': x1, 'y1': y1, 'z1': z1, 'timestamp': timestamp});


}



