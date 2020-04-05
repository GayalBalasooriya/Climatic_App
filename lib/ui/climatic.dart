import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Climatic App"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: showStuff,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/umbrella.png",
              //width: 400.0,
              fit: BoxFit.fill,
              height: 1200.0,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text("Spoken",
              style: cityStyle()
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png")
          ),

          //Container which we have our weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 390.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: updateTempWidget("san+francisco"),

          )
        ]
      )
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=imperial";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder (
      future: getWeather(util.appId, city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        // Where we get all of the json data, we setup widgets etc.
        if(snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(content['main']['temp'].toString(),
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                )
              ]
            )
          );
        } else {
          return new Container(

          );
        }
      }
    );
  }

}
TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}
TextStyle tempStyle() {
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );
}