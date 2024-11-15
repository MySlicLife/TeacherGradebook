import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teacher_gradebook/storage/course/course.dart';
import 'package:teacher_gradebook/storage/school_year/year.dart';
import 'package:teacher_gradebook/storage/student/student.dart';

import 'assignment/assignment.dart';
import 'grade/grade.dart';

class TeacherRepo {
  late Future<Isar> _teacherDB;

  TeacherRepo() {
    _teacherDB = openDatabase();
  }
  //Getter to access isar instance
  Future<Isar> get db async {
    return await _teacherDB;
  }

  //Open Database
  Future<Isar> openDatabase() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationCacheDirectory();
      final isar =
          await Isar.open([YearSchema, CourseSchema], directory: dir.path);
      return isar;
    }
    return Future.value(Isar.getInstance());
  }

  //Load Years
  Future<List<Year>> loadAllYears() async {
    final Isar dbInstance = await _teacherDB;
    final years = await dbInstance.years.where().findAll();
    return years;
  }

  //Get current year
  Future<Year?> getYear(Id yearId) async {
    final Isar dbInstance = await _teacherDB;
    return await dbInstance.years.get(yearId);
  }

  //Create Year
  Future<Year> createYear(
      {required String name, int? yearColorId, required DateTime startDate, required DateTime endDate, required String schoolName, required String location}) async {
    try {
      final Isar dbInstance = await _teacherDB;
      final Year newYear = Year(
          year: name,
          yearColorId: yearColorId ?? 0,
          startDate: startDate,
          endDate: endDate,
          schoolName: schoolName,
          location: location);
      await dbInstance.writeTxn(() async {
        await dbInstance.years.put(newYear);
      });

      return newYear;
    } catch (e) {
      throw Exception("Failed to fetch year $e");
    }
  }

  //Edit Year
  Future<Year> editYear(
      {required Id id,
      String? name,
      int? yearColorId,
      DateTime? startDate,
      DateTime? endDate,
      String? schoolName,
      String? location,
      }) async {
    final Isar dbInstance = await _teacherDB;
    final Year? existingYear = await dbInstance.years.get(id);

    if (existingYear != null) {
      existingYear.year = name ?? existingYear.year;
      existingYear.yearColorId = yearColorId ?? existingYear.yearColorId;
      existingYear.startDate = startDate ?? existingYear.startDate;
      existingYear.endDate = endDate ?? existingYear.endDate;
      existingYear.schoolName = schoolName ?? existingYear.schoolName;
      existingYear.location = location ?? existingYear.location;
      await dbInstance.writeTxn(() async {
        await dbInstance.years.put(existingYear);
      });
    } else {
      throw Exception("Cannot find school year");
    }

    return existingYear;
  }

// Delete Year
Future<void> deleteYear({required Id id}) async {
  final Isar dbInstance = await _teacherDB;

  await dbInstance.writeTxn(() async {
    final yearToDelete = await dbInstance.years.get(id);

    if (yearToDelete != null) {
      // Load linked courses
      await yearToDelete.courses.load();

      // Iterate over linked courses
      for (var course in yearToDelete.courses) {
        // Load linked students for the course
        await course.students.load();

        // Iterate over students and delete their grades
        for (var student in course.students) {
          // Load grades for each student
          await student.grades.load(); // Assuming there is an IsarLink<Grade>

          // Delete the grades
          await dbInstance.grades.deleteAll(student.grades.map((grade) => grade.id).toList());
        }

        // Delete all students linked to the course
        await dbInstance.students.deleteAll(course.students.map((student) => student.id).toList());

        // Load assignments linked to the course and delete them
        await course.assignments.load();
        await dbInstance.assignments.deleteAll(course.assignments.map((assignment) => assignment.id).toList());

        // Finally, delete the course
        await dbInstance.courses.delete(course.courseId);
      }
    }

    // Now delete the year itself
    await dbInstance.years.delete(id);
  });
}



  //Load Courses
  Future<List<Course>> loadAllCourses(Id yearId) async {
    final Isar dbInstance = await _teacherDB;
    final year = await dbInstance.years.get(yearId);
    if (year != null) {
      return year.courses.toList();
    }

    throw Exception("Failed to fetch courses");
  }

  //Get current course
  Future<Course?> getCourse(Id courseId) async {
    final Isar dbInstance = await _teacherDB;
    final course = await dbInstance.courses.get(courseId);
    return course;
  }

  //Create Course
  Future<Course> createCourse(
      {required String courseName,
      required String coursePeriod,
      required Id yearId,
      required List<double> thresholds}) async {
    try {
      final Isar dbInstance = await _teacherDB;
      final Year? schoolYear = await dbInstance.years.get(yearId);
      final Course newCourse =
          Course(courseName: courseName, coursePeriod: coursePeriod, thresholds: thresholds)
            ..schoolYear.value = schoolYear;

      dbInstance.writeTxnSync(() {
        dbInstance.courses.putSync(newCourse);
      });

      return newCourse;
    } catch (e) {
      throw Exception("Failed to fetch course $e");
    }
  }

  //Edit Course
  Future<Course> editCourse(
      {required Id id,
      String? courseName,
      String? coursePeriod,
      List<double>? thresholds,
      required Id yearId}) async {
    final Isar dbInstance = await _teacherDB;
    final Year? schoolYear = await dbInstance.years.get(yearId);
    final Course? existingCourse = await dbInstance.courses.get(id);

    if (existingCourse != null) {
      existingCourse.courseName = courseName ?? existingCourse.courseName;
      existingCourse.coursePeriod = coursePeriod ?? existingCourse.coursePeriod;
      existingCourse.thresholds = thresholds ?? existingCourse.thresholds;
      existingCourse.schoolYear.value = schoolYear;

      dbInstance.writeTxnSync(() {
        dbInstance.courses.putSync(existingCourse);
      });
    } else {
      throw Exception("Cannot find course");
    }

    return existingCourse;
  }

// Delete Course
Future<void> deleteCourse({required Id id}) async {
  final Isar dbInstance = await _teacherDB;

  await dbInstance.writeTxn(() async {
    // Find the course to be deleted
    final courseToDelete = await dbInstance.courses.get(id);
    
    if (courseToDelete != null) {
      // Load linked assignments
      await courseToDelete.assignments.load();

      // Iterate over linked assignments and delete their grades
      for (var assignment in courseToDelete.assignments) {
        await assignment.grades.load();

        // Delete all grades linked to this assignment
        await dbInstance.grades.deleteAll(assignment.grades.map((grade) => grade.id).toList());
      }

      // Load linked students for the course
      await courseToDelete.students.load();

      // Delete all linked students
      await dbInstance.students.deleteAll(courseToDelete.students.map((student) => student.id).toList());

      // Now delete all assignments linked to the course
      await dbInstance.assignments.deleteAll(courseToDelete.assignments.map((assignment) => assignment.id).toList());

      // Finally, delete the course itself
      await dbInstance.courses.delete(id);
    }
  });
}


  //Load assignments by course
  Future<List<Assignment>> loadAllAssignmentsByCourse(Id courseId) async {
    final Isar dbInstance = await _teacherDB;
    final currentCourse = await dbInstance.courses.get(courseId);
    if (currentCourse != null) {
      return currentCourse.assignments.toList();
    }
    throw Exception("Failed to fetch assignments by coures");
  }

  //Get assignment
  Future<Assignment?> getAssignment(Id assignmentId) async {
    final Isar dbInstance = await _teacherDB;
    final assignment = await dbInstance.assignments.get(assignmentId);
    return assignment;
  }

  //Create assignment
  Future<Assignment> createAssignment(
      {required String assignmentName,
      required List<Course> courses,
      required double maximumPoints}) async {
    try {
      final Isar dbInstance = await _teacherDB;
      final Assignment newAssignment = Assignment(
          assignmentName: assignmentName, maximumPoints: maximumPoints);

      for (var course in courses) {
        newAssignment.courses.add(course);
      }

      dbInstance.writeTxnSync(() {
        dbInstance.assignments.putSync(newAssignment);
      });

      return newAssignment;
    } catch (e) {
      throw Exception("Failed to fetch course $e");
    }
  }

  //Edit assignment
  Future<Assignment> editAssignment(
      {required Id assignmentId,
      String? assignmentName,
      required List<Course> courses,
      double? maximumPoints}) async {
    final Isar dbInstance = await _teacherDB;
    //Get existing Assignment
    final Assignment? existingAssignment =
        await dbInstance.assignments.get(assignmentId);
    if (existingAssignment == null) {
      throw Exception("Assignment with ID $assignmentId not found");
    } else {
      existingAssignment.assignmentName =
          assignmentName ?? existingAssignment.assignmentName;
      existingAssignment.maximumPoints =
          maximumPoints ?? existingAssignment.maximumPoints;

      //Add courses
      // Add new courses
      for (var course in courses) {
        if (!existingAssignment.courses.contains(course)) {
          existingAssignment.courses.add(course);
        }
      }

      // Remove courses that are no longer selected
      existingAssignment.courses
          .removeWhere((existingCourse) => !courses.contains(existingCourse));

      dbInstance.writeTxnSync(() {
        dbInstance.assignments.putSync(existingAssignment);
      });
      return existingAssignment;
    }
  }

// Delete Assignment
Future<void> deleteAssignment({required Id id}) async {
  final Isar dbInstance = await _teacherDB;
  await dbInstance.writeTxn(() async {
    final assignmentToDelete = await dbInstance.assignments.get(id);

    if (assignmentToDelete != null) {
      // Load linked grades for the assignment
      await assignmentToDelete.grades.load();

      // Delete all grades associated with this assignment
      for (var grade in assignmentToDelete.grades) {
        await dbInstance.grades.delete(grade.id);
      }

      // Now delete the assignment itself
      await dbInstance.assignments.delete(id);
    }
  });
}


  //Load Students by Assignment
  //Future<List<Student>> getStudentsByAssignment() async {}

  //Load Students by Year
  //Future<List<Student>> getStudentsByYear() async {}

  //Load Students by Course
  Future<List<Student>> getStudentsByCourse(Id courseId) async {
    final Isar dbInstance = await _teacherDB;
    final currentCourse = await dbInstance.courses.get(courseId);
    if (currentCourse != null) {
      return currentCourse.students.toList();
    }
    throw Exception("Failed to fetch students by coures");
  }

  //Load Student
  Future<Student?> getStudentByIsar(Id isarStudentId) async {
    final Isar dbInstance = await _teacherDB;
    final student = await dbInstance.students.get(isarStudentId);
    return student;
  }

  //Add Student
  Future<Student> createStudent(
      {required String studentName,
      int? studentId,
      int? programId,
      required List<Id> courseIds}) async {
    try {
      final Isar dbInstance = await _teacherDB;
      final newStudent = Student(
          studentName: studentName, studentId: studentId, programId: programId);

      for (var courseId in courseIds) {
        final Course? course = await dbInstance.courses.get(courseId);
        if (course != null) {
          newStudent.courses.add(course);
        }
      }

      dbInstance.writeTxnSync(() {
        dbInstance.students.putSync(newStudent);
      });
      return newStudent;
    } catch (e) {
      throw Exception("Cannot find student");
    }
  }

  //Edit Student
  Future<Student> editStudent(
      {required isarStudentId,
      String? studentName,
      int? studentId,
      int? programId,
      required List<Id> courseIds}) async {
    final Isar dbInstance = await _teacherDB;

    //Get existing Student
    final Student? existingStudent =
        await dbInstance.students.get(isarStudentId);
    if (existingStudent == null) {
      throw Exception("Assignment with ID $isarStudentId not found");
    } else {
      existingStudent.studentName = studentName ?? existingStudent.studentName;
      existingStudent.studentId = studentId ?? existingStudent.studentId;
      existingStudent.programId = studentId ?? existingStudent.programId;

      //Add course IDs
      for (var courseId in courseIds) {
        final Course? course = await dbInstance.courses.get(courseId);
        if (course != null) {
          existingStudent.courses.add(course);
        }
      }
      dbInstance.writeTxnSync(() {
        dbInstance.students.putSync(existingStudent);
      });
    }
    return existingStudent;
  }

// Delete Student
Future<void> deleteStudent({required Id studentId}) async {
  final Isar dbInstance = await _teacherDB;
  await dbInstance.writeTxn(() async {
    final studentToDelete = await dbInstance.students.get(studentId);

    if (studentToDelete != null) {
      // Load linked grades for the student
      await studentToDelete.grades.load();

      // Delete all grades associated with this student
      await dbInstance.grades.deleteAll(studentToDelete.grades.map((grade) => grade.id).toList());

      // Now delete the student itself
      await dbInstance.students.delete(studentId);
    }
  });
}


  //Load all grades by assignment
  Future<List<Grade>> getGradesByAssignment(Id assignmentId) async {
    final Isar dbInstance = await _teacherDB;
    final currentAssignment = await dbInstance.assignments.get(assignmentId);
    if (currentAssignment == null) {
      throw Exception("Cannot fetch assignment with ID $assignmentId");
    } else {
      return currentAssignment.grades.toList();
    }
  }

// Load all grades by student
Future<List<Grade>> getGradesByStudent(Id isarStudentId) async {
  final Isar dbInstance = await _teacherDB;
  final currentStudent = await dbInstance.students.get(isarStudentId);
  
  if (currentStudent == null) {
    throw Exception("Cannot fetch student with ID $isarStudentId");
  } else {
    // Calculate the new grade
    double newCalculatedGrade = currentStudent.calculateGrades(currentStudent.grades.toList());

    // Only update if the new calculated grade is different from the existing one
    if (newCalculatedGrade != currentStudent.studentNumberGrade) {
      currentStudent.studentNumberGrade = newCalculatedGrade; // Update the studentNumberGrade

        for (var course in currentStudent.courses.toList()) {
          currentStudent.studentLetterGrade = course.getLetterGrade(newCalculatedGrade);
        }


      // Save the updated student object back to the database
      await dbInstance.writeTxn(() async {
        await dbInstance.students.put(currentStudent); // Update the student record
      });
    }

    return currentStudent.grades.toList();
  }
}


  //Load singular grade
  Future<Grade> getGrade(Id gradeId) async {
    final Isar dbInstance = await _teacherDB;

    final Grade? fetchedGrade = await dbInstance.grades.get(gradeId);
    if (fetchedGrade == null) {
      throw Exception("Cannot find fetched grade with ID $gradeId");
    } else {
      return fetchedGrade;
    }
  }

  //Add grade
  Future<Grade> addGrade(
      {required double? pointsEarned,
      required double pointsPossible,
      required Id isarStudentId,
      required Id assignmentId,
      bool? isCompleted,
      bool? isLate,
      bool? isMissing}) async {
    final Isar dbInstance = await _teacherDB;

    final student = await dbInstance.students.get(isarStudentId);
    final assignment = await dbInstance.assignments.get(assignmentId);

    if (student != null && assignment != null) {
      final Grade newGrade =
          Grade(pointsEarned: pointsEarned, pointsPossible: pointsPossible, isComplete: isCompleted, isLate: isLate, isMissing: isMissing)
            ..assignment.value = assignment
            ..student.value = student;
      dbInstance.writeTxnSync(() {
        dbInstance.grades.putSync(newGrade);
      });
      return newGrade;
    } else {
      throw Exception("Cannot find assignment or grade");
    }
  }

  //Edit grade
  Future<Grade> editGrade({
    required gradeId,
    required double? pointsEarned,
    double? pointsPossible,
    bool? isCompleted, bool? isLate, bool? isMissing
  }) async {
    final Isar dbInstance = await _teacherDB;

    //Get existing grade
    final Grade? existingGrade = await dbInstance.grades.get(gradeId);

    if (existingGrade == null) {
      throw Exception("Grade with ID $gradeId not found");
    } else {
      existingGrade.pointsEarned = pointsEarned;
      existingGrade.pointsPossible =
          pointsPossible ?? existingGrade.pointsPossible;
      existingGrade.isComplete = isCompleted ?? existingGrade.isComplete;
      existingGrade.isLate = isLate ?? existingGrade.isLate;
      existingGrade.isMissing = isMissing ?? existingGrade.isMissing;
      await dbInstance.writeTxn(() async {
        await dbInstance.grades.put(existingGrade);
      });
    }

    return existingGrade;
  }

  //Delete grade
  Future<void> deleteGrade({required Id gradeId}) async {
    final Isar dbInstance = await _teacherDB;
    await dbInstance.writeTxn(() async {
      dbInstance.grades.delete(gradeId);
    });
  }
}
