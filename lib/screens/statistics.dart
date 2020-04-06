import 'package:flutter/material.dart';
//import 'package:tojuwa/widgets/dev_scaffold.dart';
import 'package:tojuwa/utils/bar_chart.dart';
import 'package:tojuwa/utils/pie_chart.dart';
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
  // Animation animation;
  // AnimationController animationController;
  bool _isFetching = false;
  var _allData;
  final List<ChartData> _chartData = [];

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
          _chartData.insert(
              0,
              ChartData(
                  name: "Cases",
                  amount: int.tryParse(
                      json.decode(response.body.toString())[0]["values"]),
                  barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
          _chartData.insert(
              1,
              ChartData(
                  name: "Recovered",
                  amount: int.tryParse(
                      json.decode(response.body.toString())[1]["values"]),
                  barColor: charts.ColorUtil.fromDartColor(Colors.green)));
          _chartData.insert(
              2,
              ChartData(
                  name: "Deaths",
                  amount: int.tryParse(
                      json.decode(response.body.toString())[2]["values"]),
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
    // animationController = AnimationController(
    //   duration: Duration(milliseconds: 3000), vsync: this
    // );
    // animation = Tween(begin: 0.0, end: 1500.0).animate(animationController)
    //   ..addListener(() {
    //     setState(() {});
    //   });
    // animationController.forward();
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
                    PieChart(data: _chartData,),
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
