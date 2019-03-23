import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/utils.dart' as util;
import './settings.dart';

class Klimatic extends StatefulWidget{
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String cityName = util.defaultCity;

  String unitSystem = util.defaultUnitSystem;

  Future _gotoSettingsScreen(BuildContext context) async {
    Map settingsResponse = await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context) => Settings(unitSystem: unitSystem))
    );

    if (settingsResponse != null) {
      if (settingsResponse.containsKey('cityName') && settingsResponse['cityName'] != '') {
        setState(() {
          cityName = settingsResponse['cityName'];
        });
      }

      if (settingsResponse.containsKey('unitSystem')) {
        setState(() {
          unitSystem = settingsResponse['unitSystem'];
        });
      }
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

          updateTempWidget(cityName),
        ],
      )
    );
  }


  Future<Map> getWeather(String city) async {
    String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&units=$unitSystem&appid=${util.apiId}";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  String _getWeatherIcon(String description) => ({
    'clear sky': 'clear',
    'few clouds': 'few-clouds',
    'scattered clouds': 'clouds',
    'broken clouds': 'clouds',
    'shower rain': 'showers-day',
    'rain': 'rain-day',
    'thunderstorm': 'storm',
    'snow': 'snow',
    'mist': 'mist',
    'haze': 'mist',
    'smoke': 'fog',
  })[description];


  Widget updateTempWidget(String city) => FutureBuilder(
    future: getWeather(city),
    builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
      if (snapshot.hasData) {
        Map content = snapshot.data;
        return Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: Image.asset("images/weather_icons/weather-${_getWeatherIcon(content['weather'][0]['description'])}.png"),
            ),


            Container(
              margin: const EdgeInsets.fromLTRB(30, 350, 0, 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "${content['main']['temp']} ${unitSystem == 'metric' ? 'C' : 'F'}",
                      style: tempStyle,
                    ),

                    subtitle: ListTile(
                        title: Text(
                            "Humidity: ${content['main']['humidity']}\n"
                                "Min: ${content['main']['temp_min']}\n"
                                "Max: ${content['main']['temp_max']}",
                            style: TextStyle(
                              color: Colors.white,
                            )
                        )
                    ),
                  )
                ],
              ),
            )
          ],
        );
      } else {
        return Container();
      }
    }
  );

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
