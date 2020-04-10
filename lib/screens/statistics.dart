import 'package:flutter/material.dart';
//import 'package:tojuwa/widgets/dev_scaffold.dart';
import 'package:tojuwa/utils/bar_chart.dart';
import 'package:tojuwa/utils/pie_chart.dart';
import 'package:tojuwa/utils/line_chart.dart';
import 'package:tojuwa/models/chart_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:date_format/date_format.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String totalTested;
  int totalCases = 0;
  int deaths = 0;
  int recovered = 0;
  double fatality = 0;
  double recovery = 0;
  int admissions = 0;
  bool _isFetching = false;
  var _allData;
  final List<ChartData> _chartData = [];
  final List<ChartData> _pieData = [];

  void _fetchChartData() async {
    if (!_isFetching) {
      setState(() {
        _isFetching = true;
      });

      final response =
          await http.get("https://covid9ja.herokuapp.com/api/confirmed/");
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          _allData = json.decode(response.body);
          totalTested = _allData[0]['values'];
          totalCases = int.tryParse(_allData[1]['values']);
          deaths = int.tryParse(_allData[3]['values']);
          recovered = int.tryParse(_allData[2]['values']);
          fatality = double.parse(
              ((deaths.toDouble() * 100) / totalCases.toDouble())
                  .toStringAsFixed(2));
          recovery = double.parse(
              ((recovered.toDouble() * 100) / totalCases.toDouble())
                  .toStringAsFixed(2));
          admissions = totalCases - recovered - deaths;
          _chartData.insert(
              0,
              ChartData(
                  name: "Cases",
                  amount: totalCases,
                  barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
          _chartData.insert(
              1,
              ChartData(
                  name: "Recovered",
                  amount: recovered,
                  barColor: charts.ColorUtil.fromDartColor(Colors.green)));
          _chartData.insert(
              2,
              ChartData(
                  name: "Deaths",
                  amount: deaths,
                  barColor: charts.ColorUtil.fromDartColor(Colors.red)));
          _pieData.insert(
              0,
              ChartData(
                  name: "Recovered",
                  amount: recovered,
                  barColor: charts.ColorUtil.fromDartColor(Colors.green)));
          _pieData.insert(
              1,
              ChartData(
                  name: "Admitted",
                  amount: totalCases - recovered - deaths,
                  barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
          _pieData.insert(
              2,
              ChartData(
                  name: "Deaths",
                  amount: deaths,
                  barColor: charts.ColorUtil.fromDartColor(Colors.red)));
          _isFetching = false;
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Make sure you have internet connection.",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            textColor: Colors.white,
            label: "Try Again",
            onPressed: _fetchChartData,
          ),
        ));
      }
    }
  }

  _timestampToDate() {
    var date = new DateTime.now();
    var fd =
        formatDate(date, [MM, " ", d, ", ", yyyy, ", ", HH, ":", nn, " ", am]);
    return fd;
  }

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Stats Area"),
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _fetchChartData,
            ),
          ]),
      body: Center(
        child: Container(
          // height: animation.value,
          // width: animation.value,
          child: ListView(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
            children: _isFetching
                ? <Widget>[
                    Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                  ]
                : <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Center(
                      child: Text(
                        "Cases in Nigeria",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    BarChart(data: _chartData),
                    Center(
                      child: Text("As of " + _timestampToDate(),
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                    ),
                    PieChart(
                      data: _pieData,
                    ),
                    Center(
                      child: Text("Total Tested: $totalTested",
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Total Cases: $totalCases",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue)),
                        ),
//                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Total Admissions: $admissions",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue)),
                        ),
//                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Recovered: $recovered",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.green)),
                        ),
//                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Recovery Rate: $recovery%",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.green)),
                        ),
//                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Deaths: $deaths",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.red)),
                        ),
//                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Fatality Rate: $fatality%",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.red)),
                        ),
//                        ),
                      ],
                    ),
//              SizedBox(
//                height: 5.0,
//              ),
//             LineChart(data: _chartData,),
                  ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //animationController.dispose();
    super.dispose();
  }
}
