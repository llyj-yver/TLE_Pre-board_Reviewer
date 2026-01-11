import 'package:flutter/material.dart';
import '../widgets/exam_widget.dart';
import '../data/exploratory_data.dart';
import '../data/questions_data.dart';
import '../widgets/exam_view.dart';
import '../models/quiz_question.dart';
import '../services/csv_quiz_parser.dart';
import '../widgets/question_card.dart';
import '../database/quiz_db.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  // Apple Calculator inspired color palette
  static const Color bgDark = Color(0xFF1C1C1E);
  static const Color cardDark = Color(0xFF2C2C2E);
  static const Color accentOrange = Color(0xFFFF9F0A);
  static const Color accentGray = Color(0xFF505050);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFF8E8E93);

  bool showExploratory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Assessments",
          style: TextStyle(
            color: textWhite,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Section Label
            Text(
              "MAIN ASSESSMENTS",
              style: TextStyle(
                color: textGray,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            // PRE TEST
            _buildMinimalCard(
              context: context,
              icon: Icons.play_circle_outline,
              title: "Pre-Test",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExamWidget(
                      questions: tlePreTestData,
                      examType: "pre-test",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // POST TEST
            _buildMinimalCard(
              context: context,
              icon: Icons.check_circle_outline,
              title: "Post-Test",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExamWidget(
                      questions: tlePostTestData,
                      examType: "post-test",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Exploratory Section
            Text(
              "EXPLORATORY COURSES",
              style: TextStyle(
                color: textGray,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            // EXPLORATORY TOGGLE
            _buildExpandableCard(
              context: context,
              icon: Icons.school_outlined,
              title: "Exploratory Courses",
              isExpanded: showExploratory,
              onTap: () {
                setState(() {
                  showExploratory = !showExploratory;
                });
              },
            ),

            // EXPLORATORY BUTTONS
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    _buildSubCard(
                      context: context,
                      title: "Industrial Arts",
                      examTitle: "Industrial Arts",
                      data: iaData,
                    ),
                    const SizedBox(height: 8),
                    _buildSubCard(
                      context: context,
                      title: "Home Economics",
                      examTitle: "Home Economics",
                      data: heData,
                    ),
                    const SizedBox(height: 8),
                    _buildSubCard(
                      context: context,
                      title: "Agri-Fishery",
                      examTitle: "Agri-Fishery",
                      data: agriFisheryData,
                    ),
                    const SizedBox(height: 8),
                    _buildSubCard(
                      context: context,
                      title: "ICT",
                      examTitle: "ICT",
                      data: ictData,
                    ),
                    const SizedBox(height: 8),
                    _buildSubCard(
                      context: context,
                      title: "Entrepreneurship",
                      examTitle: "Entrepreneurship",
                      data: entrepData,
                    ),
                    const SizedBox(height: 8),
                    _buildSubCard(
                      context: context,
                      title: "Technology & Livelihood",
                      examTitle: "Technology & Livelihood",
                      data: ttlData,
                    ),
                  ],
                ),
              ),
              crossFadeState: showExploratory
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: textWhite, size: 22),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: textWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: textWhite, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: textWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: textGray,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCard({
    required BuildContext context,
    required String title,
    required String examTitle,
    required List<List<String>> data,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: accentGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExamView(
                  title: examTitle,
                  data: data,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: textWhite.withOpacity(0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}