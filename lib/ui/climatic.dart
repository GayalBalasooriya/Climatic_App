import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {

  String _cityName;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      MaterialPageRoute<Map>(
        builder: (BuildContext context) {
          return ChangeCity();
        }
      )
    );
    if(results != null && results.containsKey('enter')) {
      print(results['enter'].toString());
      _cityName = results['enter'].toString();

    }
  }

//  void showStuff() async {
//    Map data = await getWeather(util.appId, util.defaultCity);
//    print(data.toString());
//  }

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
            onPressed: () {
              _goToNextScreen(context);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/umbrella.png",
              fit: BoxFit.fill,
              width: 490.0,
              height: 1200.0,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text("${_cityName == null ? util.defaultCity : _cityName}",
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
            child: updateTempWidget(_cityName == null ? util.defaultCity : _cityName),

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
    return new FutureBuilder<Map> (
      future: getWeather(util.appId, city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        // Where we get all of the json data, we setup widgets etc.
        if(snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
            child: new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text(content['main']['temp'].toString() + "F",
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )
                  ),

                  subtitle: ListTile(
                    title: Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()} F\n"
                          "Max: ${content['main']['temp_max'].toString()} F\n",
                      style: extraData(),
                    )
                  )
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

class ChangeCity extends StatelessWidget {

  var _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change City"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset("images/white_snow.png",
                fit: BoxFit.fill,
              width: 490.0,
              //height: 1200.0,
            ),
          ),

          ListView(
            children: <Widget>[
              ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter City'
                    ),
                    controller: _cityFieldController,
                    keyboardType: TextInputType.text,
                  )
              ),

              ListTile(
                  title: FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'enter': _cityFieldController.text,
                      });
                    },
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    child: Text("Get Weather"),
                  )
              )
            ]
          )
        ],
      )


    );
  }
}

TextStyle extraData() {
  return new TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontSize: 17
  );
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