/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class HorizontalBarChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  @override
  _HorizontalBarChartState createState() => _HorizontalBarChartState();

  static HorizontalBarChart buildGraph(
      List<charts.Series> series, bool animation) {
    return HorizontalBarChart(
      series,
      animate: animation,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GraphValue, String>> createGraph(
      List<GraphValue> graph) {
    final data = graph;
    return [
      new charts.Series<GraphValue, String>(
          id: 'Sales',
          domainFn: (GraphValue sales, _) => sales.name,
          measureFn: (GraphValue sales, _) => sales.value,
          data: data,
          labelAccessorFn: (GraphValue row, _) => '${row.value}',
          insideLabelStyleAccessorFn: (GraphValue sales, _) =>
              charts.TextStyleSpec(color: charts.Color.white, fontSize: 12),
          outsideLabelStyleAccessorFn: (GraphValue row, _) =>
              charts.TextStyleSpec(color: charts.Color.black, fontSize: 12),
          fillColorFn: (GraphValue sales, _) => _ < 5
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.blue.shadeDefault)
    ];
  }
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {
  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      widget.seriesList,
      animate: widget.animate,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator(),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
      secondaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
    );
  }
}

/// Sample ordinal data type.

class GraphValue {
  final String name;
  final int value;

  GraphValue(this.name, this.value);
}
