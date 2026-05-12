import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Scoregauge extends StatelessWidget {
  final double score;

  const Scoregauge({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: 270,
              sectionsSpace: 0,
              sections: [
                PieChartSectionData(
                  value: score,
                  color: riskColor(score),
                  radius: 15,
                  showTitle: false,
                ),

                PieChartSectionData(
                  value: 100 - score,
                  color: Colors.grey.shade200,
                  radius: 15,
                  showTitle: false,
                )
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${score.toInt()}',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text('Risk Score', style: TextStyle(color: const Color.fromARGB(255, 104, 103, 103), fontSize: 10),)
            ],
          )
        ],
      )
    );
  }

  Color riskColor(double score) {
    if (score >= 70) return Colors.red;
    if (score >= 40) return Colors.orange;
    if (score >= 20) return Colors.green;
    return Colors.green;
  }
}