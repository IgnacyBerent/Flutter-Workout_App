import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ExerciseProgressChart extends StatelessWidget {
  const ExerciseProgressChart(this.seriesList, this.exerciseName, {super.key});

  final List<LineSeries<ExerciseProgress, DateTime>> seriesList;
  final String exerciseName;

  double getMinValue() {
    double minValue = double.infinity;
    for (var series in seriesList) {
      for (var data in series.dataSource) {
        if (data.oneRepMax < minValue) {
          minValue = data.oneRepMax;
        }
      }
    }

    minValue = minValue - 10;
    if (minValue < 0) {
      minValue = 0;
    }
    return minValue;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat('dd/MM/yyyy'),
        title: AxisTitle(
          text: 'Date',
        ),
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(), // Add this line
        minimum: getMinValue(),
        title: AxisTitle(
          text: 'One Rep Max (kg)',
        ),
      ),
      title: ChartTitle(text: '$exerciseName Progress'),
      legend: Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x \n point.y (kg)',
        header: '',
      ),
      series: seriesList,
    );
  }
}

class ExerciseProgress {
  final DateTime time;
  final double oneRepMax;

  ExerciseProgress(this.time, this.oneRepMax);
}
