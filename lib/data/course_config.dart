class CourseItem {
  final String title;
  final String csvPath;

  CourseItem(this.title, this.csvPath);
}

final majorCourses = [
  CourseItem('Home Management', 'data/major/HOME_MANAGEMENT.csv'),
  CourseItem('Food Science and Nutrition', 'data/major/FOOD_SCIENCE_AND_NUTRITION.csv'),
  CourseItem('Food Service Management', 'data/major/SCHOOL_FOOD_SERVICE_MANAGEMENT.csv'),
  CourseItem('Family Life and Child Development', 'data/major/FAMILY_LIFE_AND_CHILD_DEVELOPMENT.csv'),
  CourseItem('Clothing Construction and Design', 'data/major/CLOTHING_CONSTRUCTION_DESIGN.csv'),
  CourseItem('Arts and Crafts', 'data/major/ARTS_AND_CRAFTS.csv'),
];

final exploratoryCourses = [
  CourseItem('home economics literacy', 'data/csv/exploratory/EXPLORATORY_1.csv'),
  CourseItem('family and consumer life skills', 'data/csv/exploratory/EXPLORATORY_2.csv'),
  CourseItem('entrepreneurship', 'data/csv/exploratory/EXPLORATORY_2.csv'),
];
