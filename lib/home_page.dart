import 'package:flutter/material.dart';
import 'package:reviwer_app/screens/review_materials.dart';
import 'screens/assessment_screen.dart';
import 'screens/pre_board_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Apple Calculator inspired color palette
  static const Color bgDark = Color(0xFF1C1C1E);
  static const Color cardDark = Color(0xFF2C2C2E);
  static const Color accentOrange = Color(0xFFFF9F0A);
  static const Color accentGray = Color(0xFF505050);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const SizedBox(height: 40),
              Text(
                'Welcome Back',
                style: TextStyle(
                  color: textGray,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Study Hub',
                style: TextStyle(
                  color: textWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),

              // Main Navigation Cards - Centered
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMinimalCard(
                        context,
                        icon: Icons.assignment_outlined,
                        title: 'Review Materials',
                        screen: const TestSelectionScreen(),
                      ),
                      _buildMinimalCard(
                        context,
                        icon: Icons.assignment_outlined,
                        title: 'Assessments',
                        screen: const AssessmentScreen(),
                      ),
                      const SizedBox(height: 12),
                      _buildMinimalCard(
                        context,
                        icon: Icons.school_outlined,
                        title: 'Pre-Board',
                        screen: const PreBoardScreen(),
                      ),
                      const SizedBox(height: 12),
                      _buildMinimalCard(
                        context,
                        icon: Icons.bar_chart_rounded,
                        title: 'Statistics',
                        screen: const StatisticsScreen(),
                      ),
                      const SizedBox(height: 12),
                      _buildMinimalCard(
                        context,
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        screen: const SettingsScreen(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget screen,
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
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
}
