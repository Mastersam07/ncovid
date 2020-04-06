import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tojuwa/screens/helpline_screen.dart';
import 'package:tojuwa/screens/news_screen.dart';
import 'package:tojuwa/screens/statistics.dart';
import 'package:tojuwa/utils/constants.dart';
import 'package:tojuwa/widgets/dev_scaffold.dart';
import 'package:tojuwa/widgets/info_box.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tojuwa/screens/precautions.dart';
//import 'package:tojuwa/network/coviddata.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int totalCases = 0;
  int deaths = 0;
  int recovered = 0;
  List states = [];


  Future<String> getTotalCasesForCorona() async {
    String url = "https://covid9ja.herokuapp.com/api/confirmed/";
    final response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    print(response.body);

    setState(() {
      var data = json.decode(response.body);
      totalCases = int.tryParse(data[0]['values']);
      deaths = int.tryParse(data[2]['values']);
      recovered = int.tryParse(data[1]['values']);
    });

    return "Success";
  }


  Future<String> getStatesData() async {
    String url = "https://covid9ja.herokuapp.com/api/states/";
    final response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    print(response.body);

    setState(() {
      var data = json.decode(response.body);
      states = data;
    });

    return "Success";
  }

  void eventsLength() {
    print(states.length);
  }

  @override
  void initState() {
    getTotalCasesForCorona();
    getStatesData();
    Timer.periodic(
      Duration(hours: 1),
      (Timer t) => getTotalCasesForCorona(),
    );
    Timer.periodic(
      Duration(hours: 1),
      (Timer t) => getStatesData(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DevScaffold(
      title: 'Toju Wa',
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Nigeria',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        InfoBox(
                          title: 'Total cases',
                          number: totalCases,
//                          number: 12345,
                          color: Colors.blue,
                          icon: Icon(FontAwesomeIcons.globeAmericas,
                              color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 25),
                        InfoBox(
                          title: 'States',
                          color: Colors.orange,
                          icon: Icon(Icons.flag, color: Colors.white),
                          number: states.length,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: <Widget>[
                        InfoBox(
                          title: 'Deaths',
                          color: Colors.red,
                          icon: Icon(FontAwesomeIcons.skull,
                              color: Colors.white, size: 20),
                          number: deaths,
//                        number: 123,
                        ),
                        SizedBox(width: 25),
                        InfoBox(
                          title: 'Recovered',
                          number: recovered,
//                          number: 1234,
                          color: Colors.green,
                          icon: Icon(Icons.check, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: kBoxLightColor,
                        borderRadius: kBoxesRadius,
                      ),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'HeatMaps',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'See areas affected by the infection',
                          style: TextStyle(fontSize: 15),
                        ),
                        onTap: () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => HelpLine()),
//                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: kBoxLightColor,
                        borderRadius: kBoxesRadius,
                      ),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.readme,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Protective measures',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Protective measures against the coronavirus',
                          style: TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Measures()),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: kBoxLightColor,
                        borderRadius: kBoxesRadius,
                      ),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.readme,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Latest News',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Live updates about covid-19',
                          style: TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CoronaNews()),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: kBoxLightColor,
                        borderRadius: kBoxesRadius,
                      ),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.chartLine,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Statistics',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'View the stats and trends of the infection',
                          style: TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Statistics()),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: kBoxLightColor,
                        borderRadius: kBoxesRadius,
                      ),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.phoneAlt,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Helpline',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Know anyone exhibiting symptoms and need help?',
                          style: TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HelpLine()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
