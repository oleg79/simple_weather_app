import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final String unitSystem;

  Settings({Key key, this.unitSystem}): super(key: key);

  @override
  _SettingsState createState() {
    return _SettingsState(unitSystem: unitSystem);
  }
}

class _SettingsState extends State<Settings> {

  TextEditingController _cityFieldController = TextEditingController();

  String unitSystem;

  _SettingsState({this.unitSystem});

  _setUnit(String unit) {
    setState(() {
      unitSystem = unit;
    });
  }

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
                title: DropdownButton<String>(
                    value: unitSystem,
                    items: <String>['metric', 'imperial'].map((String unit) =>
                        DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit)
                        )
                    ).toList(),
                    onChanged: _setUnit
                ),
              ),

              ListTile(
                title: FlatButton(
                    onPressed: () => Navigator.pop(context, {
                      'cityName': _cityFieldController.text,
                      'unitSystem': unitSystem,
                    }),
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