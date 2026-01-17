import 'package:flutter/material.dart';
import '../widgets/learning_materials/pdf_viewer_widget.dart';

// ==================== COURSE DATA ====================
class CourseItem {
  final String title;
  final String pdfPath;

  CourseItem(this.title, this.pdfPath);
}

final majorCourses = [
  CourseItem('Home Management', 'assets/pdf/HOME_MANAGEMENT.pdf'),
  CourseItem('Food Science and Nutrition', 'assets/pdf/FOOD_SCIENCE_AND_NUTRITION.pdf'),
  CourseItem('Food Service Management', 'assets/pdf/SCHOOL_FOOD_SERVICE_MANAGEMENT.pdf'),
  CourseItem('Family Life and Child Development', 'assets/pdf/FAMILY_LIFE_AND_CHILD_DEVELOPMENT.pdf'),
  CourseItem('Clothing Construction and Design', 'assets/pdf/CLOTHING_CONSTRUCTION_DESIGN.pdf'),
  CourseItem('Arts and Crafts', 'assets/pdf/ARTS_AND_CRAFTS.pdf'),
];

final exploratoryCourses = [
  CourseItem('Home Economics Literacy', 'assets/pdf/HOME_ECONOMICS_LITERACY.pdf'),
  CourseItem('Family and Consumer Life Skills', 'assets/pdf/FAMILY_AND_CONSUMER_LIFE_SKILLS.pdf'),
  CourseItem('Entrepreneurship', 'assets/pdf/ENTREPRENEURSHIP.pdf'),
];

// ==================== SCREEN ====================
class ReviewMaterialsScreen extends StatelessWidget {
  const ReviewMaterialsScreen({super.key});

  // ==================== BLUE & WHITE COLORS ====================
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color bgWhite = Colors.white;
  static const Color cardWhite = Color(0xFFFAFAFA);
  static const Color textDark = Color(0xFF212121);
  static const Color textGray = Color(0xFF757575);
  static const Color borderGray = Color(0xFFE0E0E0);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      appBar: AppBar(
        backgroundColor: bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review Materials',
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Study Materials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Access comprehensive course materials and guides',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.library_books,
                    label: 'Major Courses',
                    value: '${majorCourses.length}',
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.explore,
                    label: 'Exploratory',
                    value: '${exploratoryCourses.length}',
                    color: accentPurple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Major Courses Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.school,
                    color: primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Major Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...majorCourses.map((course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCourseCard(
                    context,
                    course: course,
                    color: primaryBlue,
                    icon: Icons.picture_as_pdf,
                  ),
                )),

            const SizedBox(height: 32),

            // Exploratory Courses Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.explore,
                    color: accentPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Exploratory Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...exploratoryCourses.map((course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCourseCard(
                    context,
                    course: course,
                    color: accentPurple,
                    icon: Icons.picture_as_pdf,
                  ),
                )),

            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tap any course to view the PDF material',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==================== STAT CARD ====================
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

  // ==================== COURSE CARD ====================
  Widget _buildCourseCard(
    BuildContext context, {
    required CourseItem course,
    required Color color,
    required IconData icon,
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PDFViewerWidget(
                  pdfPath: course.pdfPath,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
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
                        course.title,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PDF Document',
                        style: TextStyle(
                          color: textGray,
                          fontSize: 13,
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