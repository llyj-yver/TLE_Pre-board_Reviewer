import 'package:flutter/material.dart';
import '../../database/exam_db.dart';

class ExamResultsTable extends StatefulWidget {
  final String examType;

  const ExamResultsTable({
    super.key,
    required this.examType,
  });

  @override
  State<ExamResultsTable> createState() => _ExamResultsTableState();
}

class _ExamResultsTableState extends State<ExamResultsTable> {
  // ==================== BLUE & WHITE COLORS ====================
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color bgWhite = Colors.white;
  static const Color cardWhite = Color(0xFFFAFAFA);
  static const Color textDark = Color(0xFF212121);
  static const Color textGray = Color(0xFF757575);
  static const Color borderGray = Color(0xFFE0E0E0);
  static const Color correctGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color incorrectRed = Color(0xFFF44336);

  late Future<List<ExamResult>> resultsFuture;

  @override
  void initState() {
    super.initState();
    resultsFuture = ExamDatabase.instance.getResultsByType(widget.examType);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamResult>>(
      future: resultsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderGray, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: textGray,
                ),
                const SizedBox(height: 16),
                Text(
                  "No records yet",
                  style: TextStyle(
                    color: textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Complete ${widget.examType} to see your results here",
                  style: TextStyle(
                    color: textGray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final results = snapshot.data!;

        // Calculate stats
        final totalAttempts = results.length;
        final averageScore = results.isEmpty
            ? 0.0
            : results.map((r) => (r.score / r.totalQuestions) * 100).reduce((a, b) => a + b) / results.length;
        final bestScore = results.isEmpty
            ? 0
            : results.map((r) => (r.score / r.totalQuestions) * 100).reduce((a, b) => a > b ? a : b);

        return Column(
          children: [
            // Stats Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.assessment,
                      label: 'Attempts',
                      value: totalAttempts.toString(),
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.trending_up,
                      label: 'Average',
                      value: '${averageScore.toStringAsFixed(0)}%',
                      color: warningOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.emoji_events,
                      label: 'Best',
                      value: '${bestScore.toStringAsFixed(0)}%',
                      color: correctGreen,
                    ),
                  ),
                ],
              ),
            ),

            // Results List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: cardWhite,
                  borderRadius: BorderRadius.circular(16),
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
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Recent Results',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Results List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.length,
                      separatorBuilder: (context, index) => Divider(
                        color: borderGray,
                        height: 1,
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) {
                        final result = results[index];
                        final percentage = (result.score / result.totalQuestions) * 100;
                        final scoreColor = _getScoreColor(result.score, result.totalQuestions);
                        
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Score Circle
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scoreColor.withOpacity(0.1),
                                  border: Border.all(color: scoreColor, width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${percentage.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        color: scoreColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: textGray,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _formatDate(result.timestamp),
                                          style: TextStyle(
                                            color: textDark,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _buildInfoChip(
                                          icon: Icons.check_circle_outline,
                                          label: '${result.score}/${result.totalQuestions}',
                                          color: primaryBlue,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildInfoChip(
                                          icon: Icons.access_time,
                                          label: result.timeTaken,
                                          color: textGray,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: scoreColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _getScoreLabel(percentage),
                                  style: TextStyle(
                                    color: scoreColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: textGray,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    final date = DateTime.parse(iso);
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  String _getScoreLabel(double percentage) {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 80) return 'Great';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Fair';
    return 'Poor';
  }

  Color _getScoreColor(int score, int total) {
    final percentage = (score / total) * 100;
    if (percentage >= 80) {
      return correctGreen;
    } else if (percentage >= 60) {
      return warningOrange;
    } else {
      return incorrectRed;
    }
  }
}