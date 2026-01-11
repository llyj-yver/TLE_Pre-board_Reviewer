import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/exam_db.dart';
import '../../utils/app_colors.dart';

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
              color: AppColors.accentOrange,
              strokeWidth: 3,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.show_chart,
                  size: 64,
                  color: AppColors.textGray,
                ),
                const SizedBox(height: 16),
                Text(
                  "No Pre-Board records available",
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Take a Pre-Board exam to see your progress",
                  style: TextStyle(
                    color: AppColors.textGray.withOpacity(0.7),
                    fontSize: 14,
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
                "Pre-Board Progress",
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your performance over ${results.length} attempt${results.length > 1 ? 's' : ''}",
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Chart
              AspectRatio(
                aspectRatio: 1.3,
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
                        color: AppColors.accentOrange,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: AppColors.accentOrange,
                              strokeWidth: 2,
                              strokeColor: AppColors.bgDark,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.accentOrange.withOpacity(0.1),
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
                          interval: results.length > 10 ? (results.length / 5).ceilToDouble() : 1,
                          getTitlesWidget: (value, meta) {
                            if (value < 1 || value > results.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                value.toInt().toString(),
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
                          interval: maxY > 20 ? (maxY / 5).ceilToDouble() : 5,
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
                      horizontalInterval: maxY > 20 ? (maxY / 5).ceilToDouble() : 5,
                      verticalInterval: results.length > 10 ? (results.length / 5).ceilToDouble() : 1,
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
                            return LineTooltipItem(
                              'Attempt ${spot.x.toInt()}\nScore: ${spot.y.toInt()}',
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
                      "Best",
                      maxScore.toInt().toString(),
                      AppColors.correctGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Average",
                      avgScore.toStringAsFixed(1),
                      AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Latest",
                      latestScore.toString(),
                      AppColors.textWhite,
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