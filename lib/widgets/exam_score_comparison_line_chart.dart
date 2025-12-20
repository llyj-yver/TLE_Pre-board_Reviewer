import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/exam_db.dart';
import '../utils/app_colors.dart';

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
              color: AppColors.accentOrange,
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
                  Icons.analytics_outlined,
                  size: 64,
                  color: AppColors.textGray,
                ),
                const SizedBox(height: 16),
                Text(
                  "No data available",
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                Icon(
                  Icons.timeline,
                  size: 64,
                  color: AppColors.textGray,
                ),
                const SizedBox(height: 16),
                Text(
                  "Take a post-test to see comparison",
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart Title
              Text(
                "Score Comparison",
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Pre-test vs Post-test Performance",
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              // Legend
              Row(
                children: [
                  _buildLegendItem("Pre-test Avg", AppColors.accentOrange),
                  const SizedBox(width: 20),
                  _buildLegendItem("Post-test", AppColors.correctGreen),
                ],
              ),
              const SizedBox(height: 24),

              // Chart
              AspectRatio(
                aspectRatio: 1.3,
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
                        color: AppColors.accentOrange,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        dashArray: [8, 4],
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.accentOrange.withOpacity(0.1),
                        ),
                      ),
                      // Post-test scores
                      LineChartBarData(
                        spots: postLine,
                        isCurved: true,
                        color: AppColors.correctGreen,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: AppColors.correctGreen,
                              strokeWidth: 2,
                              strokeColor: AppColors.bgDark,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.correctGreen.withOpacity(0.1),
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
                          reservedSize: 32,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "#${value.toInt() + 1}",
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxY > 10 ? (maxY / 5).ceilToDouble() : 2,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: AppColors.textGray,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: maxY > 10 ? (maxY / 5).ceilToDouble() : 2,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.accentGray.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: AppColors.accentGray.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: AppColors.accentGray.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => AppColors.cardDark,
                        tooltipBorderRadius: BorderRadius.circular(8),
                        tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final isPreTest = spot.barIndex == 0;
                            return LineTooltipItem(
                              '${isPreTest ? "Pre-test Avg" : "Post-test"}\n${spot.y.toInt()}',
                              TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
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

              // Stats Summary
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Pre-test",
                      preAverage.toStringAsFixed(1),
                      AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Latest",
                      postResults.last.score.toString(),
                      AppColors.correctGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Attempts",
                      postResults.length.toString(),
                      AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textGray,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}