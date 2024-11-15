

import 'package:isar/isar.dart';
import '../grade/grade.dart';
import '../course/course.dart';

part 'student.g.dart';

@collection
class Student {
  Id id = Isar.autoIncrement; //Assign Program ID to student
  late int? studentId; //Student ID provided to by school
  late int? programId; //ID given to student by program school uses

  late String studentName; //Student's first and last name
  late double? studentNumberGrade; //The student's number grade for the course
  late String? studentLetterGrade; //The student's letter grade for the course
  
  final courses = IsarLinks<Course>(); //Link to course

  @Backlink(to: "student")
  final grades = IsarLinks<Grade>(); //Backlink to grades

  

  Student({required this.studentName, this.studentId, this.programId, this.studentNumberGrade, this.studentLetterGrade});
}

extension StudentExtensions on Student {
  double calculateGrades(List<Grade> grades) {
    double totalGrade = 0;
    int validGradesCount = 0; // To keep track of valid grades

    for (var grade in grades) {
      if (grade.pointsEarned != null) {
        if (grade.weight != null) {
          totalGrade += grade.pointsEarned! * grade.weight!;
        } else {
          totalGrade += grade.pointsEarned!; // Add points if no weight
        }
        validGradesCount++; // Count only valid grades
      }
    }

    // Avoid division by zero
    if (validGradesCount > 0) {
      return double.parse((totalGrade / validGradesCount).toStringAsFixed(1)); // Update the student's number grade formatted to one decimal point
    } else {
      return 0;
    }
  }
}
