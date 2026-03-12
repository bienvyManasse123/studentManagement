import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatefulWidget {
  final Map<String, dynamic> stats;
  const StatsPage({super.key, required this.stats});
  @override State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool _showBar = true; // true = histogramme, false = camembert

  @override
  Widget build(BuildContext context) {
    final s = widget.stats;
    final mMin = (s['moyenne_min'] as num).toDouble();
    final mMax = (s['moyenne_max'] as num).toDouble();
    final nomMin = s['nom_min'] as String;
    final nomMax = s['nom_max'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques & Graphiques'),
        backgroundColor: Colors.blue, foregroundColor: Colors.white,
        actions: [
          ToggleButtons(
            isSelected: [_showBar, !_showBar],
            onPressed: (i) => setState(() => _showBar = i == 0),
            color: Colors.white70,
            selectedColor: Colors.white,
            fillColor: Colors.blue.shade700,
            children: const [
              Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.bar_chart)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.pie_chart)),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Légende
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _legendItem('Moy. Min', mMin, nomMin, Colors.red),
                    _legendItem('Moy. Max', mMax, nomMax, Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _showBar
                ? _buildBarChart(mMin, mMax, nomMin, nomMax)
                : _buildPieChart(mMin, mMax, nomMin, nomMax),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String title, double val, String nom, Color c) {
    return Column(
      children: [
        Container(width: 16, height: 16,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(val.toStringAsFixed(2),
          style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(nom, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildBarChart(double mMin, double mMax, String nomMin, String nomMax) {
    return BarChart(
      BarChartData(
        maxY: 20,
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: mMin, color: Colors.red, width: 40,
              borderRadius: BorderRadius.circular(4)),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: mMax, color: Colors.green, width: 40,
              borderRadius: BorderRadius.circular(4)),
          ]),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, _) => Text(
                val == 0 ? nomMin : nomMax,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (val, _) => Text(val.toInt().toString(),
                style: const TextStyle(fontSize: 10)),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  Widget _buildPieChart(double mMin, double mMax, String nomMin, String nomMax) {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 60,
        sections: [
          PieChartSectionData(
            value: mMin, color: Colors.red, radius: 100,
            title: '${mMin.toStringAsFixed(1)}\n$nomMin',
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
              color: Colors.white),
          ),
          PieChartSectionData(
            value: mMax, color: Colors.green, radius: 100,
            title: '${mMax.toStringAsFixed(1)}\n$nomMax',
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
              color: Colors.white),
          ),
        ],
      ),
    );
  }
}
