class CourseItem {
  final String title;
  final String csvPath;

  CourseItem(this.title, this.csvPath);
}

final majorCourses = [
  CourseItem('Home Management', 'assets/major/HOME_MANAGEMENT.csv'),
  CourseItem('Food Science and Nutrition', 'assets/major/FOOD_SCIENCE_AND_NUTRITION.csv'),
  CourseItem('Food Service Management', 'assets/major/SCHOOL_FOOD_SERVICE_MANAGEMENT.csv'),
  CourseItem('Family Life and Child Development', 'assets/major/FAMILY_LIFE_AND_CHILD_DEVELOPMENT.csv'),
  CourseItem('Clothing Construction and Design', 'assets/major/CLOTHING_CONSTRUCTION_DESIGN.csv'),
  CourseItem('Arts and Crafts', 'assets/major/ARTS_AND_CRAFTS.csv'),
];

final exploratoryCourses = [
  CourseItem('home economics literacy', 'assets/csv/exploratory/EXPLORATORY_1.csv'),
  CourseItem('family and consumer life skills', 'assets/csv/exploratory/EXPLORATORY_2.csv'),
  CourseItem('entrepreneurship', 'assets/csv/exploratory/EXPLORATORY_2.csv'),
];
