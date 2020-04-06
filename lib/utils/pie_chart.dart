import 'dart:math';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert' show json;
import 'package:tojuwa/models/chart_data.dart';

class PieChart extends StatelessWidget {
  final List<ChartData> data;

  PieChart({this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, String>> series = [
      charts.Series(
        id: "Data",
        data: data,
        domainFn: (ChartData series, _) => series.name,
        measureFn: (ChartData series, _) => series.amount,
        colorFn: (ChartData series, _) => series.barColor,
      )
    ];

    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.PieChart(
                  series,
//                    behaviors: [
//                      new charts.DatumLegend(
//                        outsideJustification:
//                            charts.OutsideJustification.endDrawArea,
//                        horizontalFirst: false,
//                        desiredMaxRows: 2,
//                        cellPadding:
//                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
//                        entryTextStyle: charts.TextStyleSpec(
//                            color: charts.MaterialPalette.purple.shadeDefault,
//                            fontSize: 11),
//                      )
//                    ],
                  animate: true,
                  defaultRenderer: new charts.ArcRendererConfig(
//                    arcLength: 4 * pi,
                    arcWidth: 60,
                    arcRendererDecorators: [new charts.ArcLabelDecorator()],
//                    arcRendererDecorators: [
//                      new charts.ArcLabelDecorator(
//                          labelPosition: charts.ArcLabelPosition.inside)
//                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
