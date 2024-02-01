import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workout_app/models/piechartsampledata.dart';

class GradientPieChart extends StatelessWidget {
  final List<ChartSampleData> data;

  const GradientPieChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final total = data.fold(0.0, (sum, item) => sum + item.y);
    data.removeWhere((element) => element.y == 0);

    for (var element in data) {
      element.y = element.y / total * 100;
    }

    const Color color_1 = Color.fromARGB(150, 182, 135, 5);
    const Color color_2 = Color.fromARGB(148, 81, 0, 119);

    List<Color> generateGradientColors(Color start, Color end, int count) {
      return List<Color>.generate(
          count, (index) => Color.lerp(start, end, index / (count - 1))!);
    }

    List<Color> gradientColors = generateGradientColors(color_1, color_2, 9);

    return Expanded(
      child: SfCircularChart(
        series: <CircularSeries<ChartSampleData, String>>[
          PieSeries<ChartSampleData, String>(
            dataSource: data,
            pointRenderMode: PointRenderMode.gradient,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.y,
            dataLabelMapper: (ChartSampleData data, _) =>
                '${data.x} \n ${data.y.toStringAsFixed(1)}%',
            pointColorMapper: (ChartSampleData data, _) =>
                gradientColors[data.index],
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
