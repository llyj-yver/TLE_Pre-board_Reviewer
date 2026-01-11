import 'package:flutter/material.dart';
import '../widgets/statistics/exam_score_comparison_line_chart.dart';
import '../widgets/statistics/pre_board_attempts_line_chart.dart';
import '../widgets/statistics/exam_results_table.dart';
import '../utils/app_colors.dart';
import '../widgets/statistics/major_average.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Statistics",
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart Section
            const ExamScoreComparisonLineChart(),
            const PreBoardAttemptsLineChart(),
            
            const SizedBox(height: 8),
            
            // Section Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "EXAM RECORDS",
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Pre-Test Records
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pre-Test Records",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const ExamResultsTable(examType: "pre-test"),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Post-Test Records
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post-Test Records",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const ExamResultsTable(examType: "post-test"),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            // Post-Test Records
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post-Test Records",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const MajorCoursesAverageWidget(),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}