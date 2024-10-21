

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../school_year/year.dart';
import '../teacher_repo.dart';
import 'course.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final TeacherRepo _teacherRepo;

  CourseCubit(this._teacherRepo) : super(CourseInitial());

  Future<void> loadCourses(Id yearId) async {
    emit(CourseLoading());
    try {
      final List<Course> courses = await _teacherRepo.loadAllCourses(yearId);
      final Year? currentYear = await _teacherRepo.getYear(yearId);

      if (currentYear != null) {
        emit(CourseLoaded(courses: courses, year: currentYear));
      } else {
        emit(CourseError(message: "Cannot find year"));
      }
    } catch (e) {
      emit(CourseError(message: "Cannot load couress"));
    }
  }

  Future<void> addCourse(String courseName, String coursePeriod, Id schoolYearId) async {
    await _teacherRepo.createCourse(courseName: courseName, coursePeriod: coursePeriod, yearId: schoolYearId);
    loadCourses(schoolYearId);
  }

  Future<void> deleteCourse(Id courseId, Id schoolYearId) async {
    await _teacherRepo.deleteCourse(id: courseId);
    loadCourses(schoolYearId);
  }

  Future<void> editCourse(Id courseId, Id schoolYearId, String? courseName, String? coursePeriod) async {
    await _teacherRepo.editCourse(id: courseId, yearId: schoolYearId, courseName: courseName, coursePeriod: coursePeriod);
    loadCourses(schoolYearId);
  }
}
