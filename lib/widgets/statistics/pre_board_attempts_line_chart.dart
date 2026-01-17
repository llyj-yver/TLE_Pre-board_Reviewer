import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/exam_db.dart';

class PreBoardAttemptsLineChart extends StatefulWidget {
  const PreBoardAttemptsLineChart({super.key});

  @override
  State<PreBoardAttemptsLineChart> createState() => _PreBoardAttemptsLineChartState();
}

class _PreBoardAttemptsLineChartState extends State<PreBoardAttemptsLineChart> {
  late Future<List<ExamResult>> preBoardResultsFuture;

  @override
  void initState() {
    super.initState();
    preBoardResultsFuture = ExamDatabase.instance.getResultsByType("pre-board");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamResult>>(
      future: preBoardResultsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF5624D0),
              strokeWidth: 3,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5624D0).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.show_chart_rounded,
                    size: 64,
                    color: const Color(0xFF5624D0),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "No Pre-Board records available",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Take a Pre-Board exam to see your progress",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }

        final results = snapshot.data!;
        List<FlSpot> spots = [];
        
        for (int i = 0; i < results.length; i++) {
          spots.add(FlSpot((i + 1).toDouble(), results[i].score.toDouble()));
        }

        final maxScore = results.map((r) => r.score).reduce((a, b) => a > b ? a : b).toDouble();
        final avgScore = results.map((r) => r.score).reduce((a, b) => a + b) / results.length;
        final latestScore = results.last.score;
        
        final maxY = (maxScore + 5).ceilToDouble();

        // Calculate improvement
        final improvement = results.length > 1 
            ? latestScore - results.first.score 
            : 0;

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
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
                      const Color(0xFF0056D2),
                      const Color(0xFF0056D2).withAlpha(217),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.assessment_outlined,
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
                            "Pre-Board Progress",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Performance over ${results.length} attempt${results.length > 1 ? 's' : ''}",
                            style: TextStyle(
                              color: Colors.white.withAlpha(230),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
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
                            icon: Icons.emoji_events_rounded,
                            label: "Best Score",
                            value: maxScore.toInt().toString(),
                            color: const Color(0xFF5624D0),
                            isHighlight: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModernStatCard(
                            icon: Icons.insights_rounded,
                            label: "Average",
                            value: avgScore.toStringAsFixed(1),
                            color: const Color(0xFF0056D2),
                            isHighlight: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModernStatCard(
                            icon: Icons.schedule_rounded,
                            label: "Latest",
                            value: latestScore.toString(),
                            color: const Color(0xFF0056D2),
                            isHighlight: false,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Chart
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: LineChart(
                        LineChartData(
                          minX: 1,
                          maxX: results.length.toDouble(),
                          minY: 0,
                          maxY: maxY,
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
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
                                    const Color(0xFF5624D0).withAlpha(64),
                                    const Color(0xFF5624D0).withAlpha(5),
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
                                interval: results.length > 10 ? (results.length / 5).ceilToDouble() : 1,
                                getTitlesWidget: (value, meta) {
                                  if (value < 1 || value > results.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Attempt ${value.toInt()}",
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
                                interval: maxY > 20 ? (maxY / 5).ceilToDouble() : 5,
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
                            horizontalInterval: maxY > 20 ? (maxY / 5).ceilToDouble() : 5,
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
                              tooltipBorder: BorderSide(
                                color: Colors.transparent,
                              ),
                              tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  return LineTooltipItem(
                                    'Attempt ${spot.x.toInt()}\n${spot.y.toInt()} points',
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
                    if (improvement > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5624D0).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF5624D0).withAlpha(77),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              color: const Color(0xFF5624D0),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Excellent! +$improvement points from first attempt",
                              style: const TextStyle(
                                color: Color(0xFF5624D0),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (improvement < 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0056D2).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF0056D2).withAlpha(77),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: const Color(0xFF0056D2),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Keep practicing! Review your mistakes to improve",
                              style: const TextStyle(
                                color: Color(0xFF0056D2),
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
        color: isHighlight ? color.withAlpha(25) : Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlight ? color.withAlpha(77) : Colors.grey[200]!,
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