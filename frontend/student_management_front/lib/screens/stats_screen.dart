import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
 
class StatsScreen extends StatefulWidget {
  final Map<String, dynamic> stats;
  const StatsScreen({super.key, required this.stats});
 
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}
 
class _StatsScreenState extends State<StatsScreen> {
  bool _showBar = true;
 
  @override
  Widget build(BuildContext context) {
    final s = widget.stats;
    final mMin = (s['moyenne_min'] as num).toDouble();
    final mMax = (s['moyenne_max'] as num).toDouble();
    final mMoy = (s['moyenne_classe'] as num).toDouble();
    final nomMin = s['nom_min'] as String;
    final nomMax = s['nom_max'] as String;
 
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(60, 60, 60, 40),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A2E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: const Text(
              'Statistiques',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
 
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
 
                  // Résumé global
                  _buildSummaryRow(s),
                  const SizedBox(height: 20),
 
                  // Toggle histogramme / camembert
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _toggleBtn('Histogramme', Icons.bar_chart, true),
                        _toggleBtn('Camembert', Icons.pie_chart, false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
 
                  // Graphique
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _showBar
                        ? _buildBarChart(mMin, mMax, mMoy, nomMin, nomMax)
                        : _buildPieChart(mMin, mMax, nomMin, nomMax),
                  ),
                  const SizedBox(height: 20),
 
                  // Légende min / max
                  Row(
                    children: [
                      Expanded(child: _buildLegendCard(
                        'Moyenne Min', mMin, nomMin, Colors.red.shade400)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildLegendCard(
                        'Moyenne Max', mMax, nomMax, Colors.green.shade400)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildSummaryRow(Map<String, dynamic> s) {
    return Row(
      children: [
        _miniStatCard('${s['admis']}', 'Admis', Colors.green.shade400),
        const SizedBox(width: 10),
        _miniStatCard('${s['redoublants']}', 'Redoublants', Colors.red.shade400),
        const SizedBox(width: 10),
        _miniStatCard('${s['total']}', 'Total', Colors.blueGrey.shade600),
      ],
    );
  }
 
  Widget _miniStatCard(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(val,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style:
                    TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
 
  Widget _toggleBtn(String label, IconData icon, bool isBar) {
    final selected = _showBar == isBar;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _showBar = isBar),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1A1A2E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected ? Colors.white : Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? Colors.white : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildBarChart(double mMin, double mMax, double mMoy,
      String nomMin, String nomMax) {
    return BarChart(
      BarChartData(
        maxY: 20,
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(
                toY: mMin,
                color: Colors.red.shade400,
                width: 36,
                borderRadius: BorderRadius.circular(6)),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(
                toY: mMoy,
                color: Colors.blue.shade400,
                width: 36,
                borderRadius: BorderRadius.circular(6)),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(
                toY: mMax,
                color: Colors.green.shade400,
                width: 36,
                borderRadius: BorderRadius.circular(6)),
          ]),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, _) {
                final labels = [nomMin.split(' ')[0], 'Classe', nomMax.split(' ')[0]];
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[val.toInt()],
                      style: const TextStyle(fontSize: 11)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (val, _) => Text(val.toInt().toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (val) => FlLine(
            color: Colors.grey.shade100,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
 
  Widget _buildPieChart(
      double mMin, double mMax, String nomMin, String nomMax) {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 55,
        sections: [
          PieChartSectionData(
            value: mMin,
            color: Colors.red.shade400,
            radius: 80,
            title: mMin.toStringAsFixed(1),
            titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          PieChartSectionData(
            value: mMax,
            color: Colors.green.shade400,
            radius: 80,
            title: mMax.toStringAsFixed(1),
            titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
 
  Widget _buildLegendCard(
      String title, double val, String nom, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 6),
          Text(val.toStringAsFixed(2),
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(nom,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}