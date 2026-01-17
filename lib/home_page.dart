import 'package:flutter/material.dart';
import 'package:reviwer_app/screens/assessment_screen.dart';
import 'screens/review_materials_screen.dart';
import 'screens/pre_board_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Modern Blue & White color palette
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color bgWhite = Colors.white;
  static const Color cardWhite = Color(0xFFFAFAFA);
  static const Color textDark = Color(0xFF212121);
  static const Color textGray = Color(0xFF757575);
  static const Color borderGray = Color(0xFFE0E0E0);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentPurple = Color(0xFF9C27B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryBlue, darkBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, Student! 👋',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ready to Learn?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          // Profile Avatar
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.person,
                              color: primaryBlue,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Search bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white.withOpacity(0.8),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Search courses...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Stats Section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.assessment,
                            label: 'Tests Taken',
                            value: '12',
                            color: accentOrange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.emoji_events,
                            label: 'Avg Score',
                            value: '85%',
                            color: accentGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Navigation Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore Learning',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Grid of Navigation Cards
                    _buildNavigationCard(
                      context,
                      icon: Icons.quiz,
                      title: 'Assessments',
                      subtitle: 'Test your knowledge',
                      screen: const TestSelectionScreen(),
                      color: primaryBlue,
                      iconBg: primaryBlue.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    _buildNavigationCard(
                      context,
                      icon: Icons.menu_book,
                      title: 'Review Materials',
                      subtitle: 'Study course content',
                      screen: const ReviewMaterialsScreen(),
                      color: accentPurple,
                      iconBg: accentPurple.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    _buildNavigationCard(
                      context,
                      icon: Icons.school,
                      title: 'Pre-Board Exam',
                      subtitle: 'Practice final exams',
                      screen: const PreBoardScreen(),
                      color: accentOrange,
                      iconBg: accentOrange.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    _buildNavigationCard(
                      context,
                      icon: Icons.bar_chart_rounded,
                      title: 'Statistics',
                      subtitle: 'Track your progress',
                      screen: const StatisticsScreen(),
                      color: accentGreen,
                      iconBg: accentGreen.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    _buildNavigationCard(
                      context,
                      icon: Icons.settings,
                      title: 'Settings',
                      subtitle: 'Customize your experience',
                      screen: const SettingsScreen(),
                      color: textGray,
                      iconBg: textGray.withOpacity(0.1),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Motivational Quote Section
              Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightBlue.withOpacity(0.3), primaryBlue.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryBlue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Tip',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Consistency is key! Study a little every day.',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 14,
                              height: 1.4,
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
        ),
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: textGray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget screen,
    required Color color,
    required Color iconBg,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: textGray,
                          fontSize: 14,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: textGray,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}