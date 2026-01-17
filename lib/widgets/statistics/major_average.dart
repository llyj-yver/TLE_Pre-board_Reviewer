import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../database/quiz_db.dart';
import '../../data/course_config.dart';

class MajorCoursesAverageWidget extends StatefulWidget {
  const MajorCoursesAverageWidget({super.key});

  @override
  State<MajorCoursesAverageWidget> createState() =>
      _MajorCoursesAverageWidgetState();
}

class _MajorCoursesAverageWidgetState
    extends State<MajorCoursesAverageWidget> {
  // ==================== BLUE & WHITE COLORS ====================
  final Color primaryBlue = const Color(0xFF2196F3);
  final Color bgWhite = Colors.white;
  final Color cardWhite = const Color(0xFFFAFAFA);
  final Color textDark = const Color(0xFF212121);
  final Color textGray = const Color(0xFF757575);
  final Color borderGray = const Color(0xFFE0E0E0);

  late Future<Map<String, double>> _averageScores;

  // Vibrant colors for radar chart
  final List<Color> radarColors = [
    const Color(0xFF2196F3), // Blue
    const Color(0xFF4CAF50), // Green
    const Color(0xFFFF9800), // Orange
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFF44336), // Red
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFFE91E63), // Pink
    const Color(0xFF009688), // Teal
  ];

  @override
  void initState() {
    super.initState();
    _averageScores = QuizDB.getAverageScoresByCourse(
      majorCourses.map((c) => c.title).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderGray, width: 1),
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
              Icon(Icons.radar, color: primaryBlue, size: 24),
              const SizedBox(width: 8),
              Text(
                'Major Courses Average Scores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FutureBuilder<Map<String, double>>(
            future: _averageScores,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: primaryBlue),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final data = snapshot.data!;

              if (data.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 48, color: textGray),
                        const SizedBox(height: 12),
                        Text(
                          'No data available yet',
                          style: TextStyle(color: textGray, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Normalize scores to 0-100 scale for radar chart
              final maxScore = 100.0; // Assuming scores are out of 100

              return Column(
                children: [
                  // Radar Chart
                  SizedBox(
                    height: 350,
                    child: Center(
                      child: CustomPaint(
                        size: const Size(320, 320),
                        painter: RadarChartPainter(
                          data: data,
                          maxValue: maxScore,
                          fillColor: primaryBlue,
                          gridColor: borderGray,
                          textColor: textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Legend with scores
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: data.entries.toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final courseEntry = entry.value;
                      
                      return Container(
                        width: MediaQuery.of(context).size.width > 600 
                            ? (MediaQuery.of(context).size.width - 100) / 2 - 20
                            : double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: bgWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: radarColors[index % radarColors.length],
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: radarColors[index % radarColors.length],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courseEntry.key,
                                    style: TextStyle(
                                      color: textDark,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${courseEntry.value.toStringAsFixed(1)} / 100',
                                    style: TextStyle(
                                      color: radarColors[index % radarColors.length],
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final Map<String, double> data;
  final double maxValue;
  final Color fillColor;
  final Color gridColor;
  final Color textColor;

  RadarChartPainter({
    required this.data,
    required this.maxValue,
    required this.fillColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 60;
    final numberOfSides = data.length;
    final angle = (2 * math.pi) / numberOfSides;

    // Draw grid circles (5 levels)
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 5; i++) {
      final gridRadius = radius * (i / 5);
      canvas.drawCircle(center, gridRadius, gridPaint);
    }

    // Draw axes and labels
    final axisPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final entries = data.entries.toList();
    
    for (int i = 0; i < numberOfSides; i++) {
      final currentAngle = -math.pi / 2 + angle * i;
      final x = center.dx + radius * math.cos(currentAngle);
      final y = center.dy + radius * math.sin(currentAngle);

      // Draw axis line
      canvas.drawLine(center, Offset(x, y), axisPaint);

      // Draw label
      final labelX = center.dx + (radius + 40) * math.cos(currentAngle);
      final labelY = center.dy + (radius + 40) * math.sin(currentAngle);

      final courseName = entries[i].key;
      final shortName = courseName.length > 15 
          ? '${courseName.substring(0, 12)}...'
          : courseName;

      final textPainter = TextPainter(
        text: TextSpan(
          text: shortName,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout(maxWidth: 100);
      
      // Center text around the point
      textPainter.paint(
        canvas,
        Offset(
          labelX - textPainter.width / 2,
          labelY - textPainter.height / 2,
        ),
      );
    }

    // Draw data polygon
    final dataPath = Path();
    final dataPoints = <Offset>[];

    for (int i = 0; i < numberOfSides; i++) {
      final currentAngle = -math.pi / 2 + angle * i;
      final value = entries[i].value;
      final normalizedValue = (value / maxValue).clamp(0.0, 1.0);
      final pointRadius = radius * normalizedValue;

      final x = center.dx + pointRadius * math.cos(currentAngle);
      final y = center.dy + pointRadius * math.sin(currentAngle);

      dataPoints.add(Offset(x, y));

      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }

    dataPath.close();

    // Fill the polygon
    final fillPaint = Paint()
      ..color = fillColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(dataPath, fillPaint);

    // Draw polygon border
    final borderPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(dataPath, borderPaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    for (final point in dataPoints) {
      canvas.drawCircle(point, 5, pointPaint);
      
      // White border for points
      final pointBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(point, 5, pointBorderPaint);
    }

    // Draw value labels on points
    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final value = entries[i].value;
      
      final valuePainter = TextPainter(
        text: TextSpan(
          text: value.toStringAsFixed(0),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            backgroundColor: Color(0xFF2196F3),
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      valuePainter.layout();
      
      // Position label slightly outside the point
      final currentAngle = -math.pi / 2 + angle * i;
      final labelOffset = 15.0;
      final labelX = point.dx + labelOffset * math.cos(currentAngle) - valuePainter.width / 2;
      final labelY = point.dy + labelOffset * math.sin(currentAngle) - valuePainter.height / 2;

      valuePainter.paint(canvas, Offset(labelX, labelY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}