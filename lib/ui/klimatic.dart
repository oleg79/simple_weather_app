import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget{
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String cityName = 'Spokane';

  Future _gotoSettingsScreen(BuildContext context) async {
    Map settingsResponse = await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context) => Settings())
    );

    if (settingsResponse.containsKey('cityName')) {
      setState(() {
        cityName = settingsResponse['cityName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klimatic'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _gotoSettingsScreen(context),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/umbrella.png',
              width: 490,
              height: 1200,
              fit: BoxFit.fill
            ),
          ),

          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0, 11, 20, 0),
            child: Text(
              cityName,
              style: cityStyle,
            )
          ),

          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(30, 350, 0, 0),
            child: updateTempWidget(cityName),
          ),
        ],
      )
    );
  }


  Future<Map> getWeather(String city) async {
    String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=${util.apiId}";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }


  Widget updateTempWidget(String city) => FutureBuilder(
    future: getWeather(city),
    builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
      if (snapshot.hasData) {
        Map content = snapshot.data;
        return Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  content['main']['temp'].toString(),
                  style: tempStyle,
                ),
              )
            ],
          ),
        );
      } else {
        return Container();
      }
    }
  );

}

class Settings extends StatelessWidget {

  TextEditingController _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Settings'),
        centerTitle: true,
      ),

      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/white_snow.png',
              width: 490,
              height: 1200,
              fit: BoxFit.fill,
            ),
          ),

          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              
              ListTile(
                title: FlatButton(
                  onPressed: () => Navigator.pop(context, { 'cityName': _cityFieldController.text }),
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: Text('Get Weather')
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}

TextStyle cityStyle = TextStyle(
  color: Colors.white,
  fontSize: 23,
  fontStyle: FontStyle.italic,
);

TextStyle tempStyle = TextStyle(
  color: Colors.white,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 50,
);
