import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/exam_db.dart';

class ExamScoreComparisonLineChart extends StatelessWidget {
  const ExamScoreComparisonLineChart({super.key});

  Future<Map<String, dynamic>> _loadData() async {
    final preResults = await ExamDatabase.instance.getResultsByType('pre-test');
    final postResults = await ExamDatabase.instance.getResultsByType('post-test');

    double preAverage = 0;
    if (preResults.isNotEmpty) {
      preAverage = preResults.map((e) => e.score).reduce((a, b) => a + b) / preResults.length;
    }

    return {
      'preAverage': preAverage,
      'postResults': postResults,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF5624D0),
              strokeWidth: 3,
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insert_chart_outlined_rounded,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "No data available",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        final double preAverage = snapshot.data!['preAverage'];
        final List<ExamResult> postResults = snapshot.data!['postResults'];

        if (postResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5624D0).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: const Color(0xFF5624D0),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Take a post-test to see comparison",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        List<FlSpot> preLine = [];
        List<FlSpot> postLine = [];

        for (int i = 0; i < postResults.length; i++) {
          preLine.add(FlSpot(i.toDouble(), preAverage));
          postLine.add(FlSpot(i.toDouble(), postResults[i].score.toDouble()));
        }

        double maxY = [
          preAverage,
          ...postResults.map((e) => e.score.toDouble())
        ].reduce((a, b) => a > b ? a : b);
        maxY = (maxY + 2).ceilToDouble();

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF5624D0),
                      const Color(0xFF5624D0).withOpacity(0.85),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.trending_up_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Performance Analytics",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Pre-test vs Post-test Comparison",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernStatCard(
                            icon: Icons.school_outlined,
                            label: "Pre-test Average",
                            value: preAverage.toStringAsFixed(1),
                            color: const Color(0xFF0056D2),
                            isHighlight: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModernStatCard(
                            icon: Icons.stars_rounded,
                            label: "Latest Score",
                            value: postResults.last.score.toString(),
                            color: const Color(0xFF5624D0),
                            isHighlight: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModernStatCard(
                            icon: Icons.repeat_rounded,
                            label: "Total Attempts",
                            value: postResults.length.toString(),
                            color: const Color(0xFF0056D2),
                            isHighlight: false,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Legend
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildModernLegend("Pre-test Average", const Color(0xFF0056D2)),
                          const SizedBox(width: 32),
                          _buildModernLegend("Post-test Scores", const Color(0xFF5624D0)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Chart
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (postResults.length - 1).toDouble(),
                          minY: 0,
                          maxY: maxY,
                          lineBarsData: [
                            // Pre-test average line
                            LineChartBarData(
                              spots: preLine,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: const Color(0xFF0056D2),
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              dashArray: [8, 5],
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF0056D2).withOpacity(0.2),
                                    const Color(0xFF0056D2).withOpacity(0.02),
                                  ],
                                ),
                              ),
                            ),
                            // Post-test scores
                            LineChartBarData(
                              spots: postLine,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: const Color(0xFF5624D0),
                              barWidth: 4,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: const Color(0xFF5624D0),
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF5624D0).withOpacity(0.25),
                                    const Color(0xFF5624D0).withOpacity(0.02),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Test #${value.toInt() + 1}",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 45,
                                interval: maxY > 10 ? (maxY / 5).ceilToDouble() : 2,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxY > 10 ? (maxY / 5).ceilToDouble() : 2,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[200],
                                strokeWidth: 1.5,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!, width: 2),
                              left: BorderSide(color: Colors.grey[300]!, width: 2),
                            ),
                          ),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (touchedSpot) => const Color(0xFF2D2F31),
                              tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final isPreTest = spot.barIndex == 0;
                                  return LineTooltipItem(
                                    '${isPreTest ? "Pre-test Avg" : "Post-test #${spot.x.toInt() + 1}"}\n${spot.y.toInt()} points',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Improvement Indicator
                    if (postResults.last.score > preAverage)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5624D0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF5624D0).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.celebration_rounded,
                              color: const Color(0xFF5624D0),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Great progress! +${(postResults.last.score - preAverage).toStringAsFixed(1)} points improvement",
                              style: const TextStyle(
                                color: Color(0xFF5624D0),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildModernStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isHighlight,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? color.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlight ? color.withOpacity(0.3) : Colors.grey[200]!,
          width: isHighlight ? 2 : 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}